<script lang="ts">
	import { searchListings, type BoatTraderListing } from '$lib/boattrader';
	import { supabase } from '$lib/supabase';
	import { getUser } from '$lib/auth.svelte';
	import { formatCurrency, formatNumber } from '$lib/utils';

	interface Props {
		make: string;
		model?: string;
		boatDesignId?: string;
		sessionId?: string | null;
		onresults?: (listings: BoatTraderListing[]) => void;
	}

	let { make, model, boatDesignId, sessionId, onresults }: Props = $props();

	const user = $derived(getUser());

	let listings = $state<BoatTraderListing[]>([]);
	let total = $state(0);
	let loading = $state(false);
	let searched = $state(false);
	let error = $state('');
	let trackedIds = $state<Set<number>>(new Set());
	let trackingId = $state<number | null>(null);

	async function handleSearch() {
		loading = true;
		error = '';
		try {
			const result = await searchListings(make, model);
			listings = result.listings;
			total = result.total;
			onresults?.(listings);

			// Check which listings are already tracked
			if (user && result.listings.length > 0) {
				const ids = result.listings.map((l) => l.id);
				const { data } = await supabase
					.from('watchlist')
					.select('boattrader_id')
					.eq('user_id', user.id)
					.in('boattrader_id', ids);
				trackedIds = new Set((data ?? []).map((d) => d.boattrader_id));
			}
			// Fire-and-forget market snapshot
			if (boatDesignId && result.listings.length > 0) {
				fetch('/api/market-snapshot', {
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify({
						boat_design_id: boatDesignId,
						listings: result.listings
					})
				}).catch(() => {});
			}
		} catch (e) {
			error = e instanceof Error ? e.message : 'Failed to fetch listings';
		}
		loading = false;
		searched = true;
	}

	async function trackListing(listing: BoatTraderListing) {
		if (!user) return;
		trackingId = listing.id;

		const { error: err } = await supabase.from('watchlist').insert({
			user_id: user.id,
			boattrader_id: listing.id,
			make: listing.make,
			model: listing.model,
			year: listing.year,
			last_asking_price: listing.priceUSD,
			last_location_city: listing.city,
			last_location_state: listing.state,
			listing_url: listing.url,
			session_id: sessionId || null,
			status: 'active',
			last_checked_at: new Date().toISOString()
		});

		if (err) {
			if (err.code === '23505') {
				// Already tracked (unique constraint)
				trackedIds = new Set([...trackedIds, listing.id]);
			} else {
				error = err.message;
			}
		} else {
			// Record initial price snapshot
			const { data: newItem } = await supabase
				.from('watchlist')
				.select('id')
				.eq('user_id', user.id)
				.eq('boattrader_id', listing.id)
				.single();

			if (newItem && listing.priceUSD) {
				await supabase.from('price_history').insert({
					watchlist_id: newItem.id,
					asking_price: listing.priceUSD,
					status: 'active'
				});
			}

			trackedIds = new Set([...trackedIds, listing.id]);
		}

		trackingId = null;
	}
</script>

<div>
	{#if !searched && !loading}
		<div class="text-center py-4">
			<p class="mb-3 text-sm text-gray-500">Search BoatTrader for {make} {model ?? ''} listings.</p>
			<button
				onclick={handleSearch}
				class="rounded-lg bg-blue-600 px-5 py-2.5 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
			>
				Search Listings
			</button>
		</div>
	{:else if loading}
		<div class="py-6 text-center">
			<div class="mx-auto h-6 w-6 animate-spin rounded-full border-4 border-gray-300 border-t-blue-500"></div>
			<p class="mt-2 text-sm text-gray-500">Searching BoatTrader...</p>
		</div>
	{:else if error}
		<div class="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{error}</div>
	{:else if listings.length === 0}
		<p class="text-sm text-gray-500">No listings found on BoatTrader for {make} {model ?? ''}.</p>
	{:else}
		<div class="mb-4 flex items-center justify-between">
			<p class="text-sm text-gray-500">{total} listing{total !== 1 ? 's' : ''} found</p>
			<button
				onclick={handleSearch}
				class="text-sm text-blue-600 hover:text-blue-800"
			>
				Refresh
			</button>
		</div>
		<div class="space-y-3">
			{#each listings as listing}
				<div class="rounded-lg border border-gray-200 bg-white p-4 hover:border-blue-300 hover:shadow transition-all">
					<div class="flex items-start justify-between">
						<div>
							<div class="font-semibold text-gray-900">
								{listing.year} {listing.make} {listing.model}
							</div>
							<div class="mt-1 text-sm text-gray-600">
								{[listing.city, listing.state].filter(Boolean).join(', ')}
							</div>
							<div class="mt-1 flex flex-wrap gap-3 text-xs text-gray-500">
								{#if listing.lengthFt}
									<span>{listing.lengthFt}ft</span>
								{/if}
								{#if listing.beamFt}
									<span>Beam: {listing.beamFt}ft</span>
								{/if}
								{#if listing.displacementLbs}
									<span>Disp: {formatNumber(listing.displacementLbs)}lbs</span>
								{/if}
								{#if listing.draftFt}
									<span>Draft: {listing.draftFt}ft</span>
								{/if}
								{#if listing.cabins}
									<span>{listing.cabins} cabin{listing.cabins !== 1 ? 's' : ''}</span>
								{/if}
								{#if listing.engineHours}
									<span>Engine: {formatNumber(listing.engineHours)}hrs</span>
								{/if}
								{#if listing.hullMaterial}
									<span>{listing.hullMaterial}</span>
								{/if}
							</div>
						</div>
						<div class="text-right">
							{#if listing.priceUSD && !listing.priceHidden}
								<div class="text-lg font-bold text-blue-600">{formatCurrency(listing.priceUSD)}</div>
							{:else}
								<div class="text-sm text-gray-400">Contact for price</div>
							{/if}
						</div>
					</div>
					<div class="mt-3 flex items-center gap-3">
						<a
							href={listing.url}
							target="_blank"
							rel="noopener noreferrer"
							class="text-xs text-blue-600 hover:text-blue-800"
						>
							View on BoatTrader
						</a>
						{#if user}
							{#if trackedIds.has(listing.id)}
								<span class="text-xs font-medium text-green-600">Tracking</span>
							{:else}
								<button
									onclick={() => trackListing(listing)}
									disabled={trackingId === listing.id}
									class="text-xs font-medium text-blue-600 hover:text-blue-800 disabled:opacity-50"
								>
									{trackingId === listing.id ? 'Saving...' : 'Track Listing'}
								</button>
							{/if}
						{/if}
					</div>
				</div>
			{/each}
		</div>
	{/if}
</div>
