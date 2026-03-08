<script lang="ts">
	import { supabase } from '$lib/supabase';
	import { getUser } from '$lib/auth.svelte';
	import { formatCurrency } from '$lib/utils';
	import type { WatchlistItem, PriceSnapshot } from '$lib/types';
	import type { BoatTraderListing } from '$lib/boattrader';
	let items = $state<WatchlistItem[]>([]);
	let loading = $state(true);
	let refreshing = $state(false);
	let error = $state('');
	let loaded = $state(false);

	const user = $derived(getUser());

	$effect(() => {
		if (user && !loaded) {
			loaded = true;
			loadWatchlist();
		}
		if (!user) {
			loading = false;
			loaded = false;
			items = [];
		}
	});

	async function loadWatchlist() {
		loading = true;
		const { data, error: err } = await supabase
			.from('watchlist')
			.select('*')
			.eq('user_id', user!.id)
			.order('created_at', { ascending: false });

		loading = false;
		if (err) {
			error = err.message;
		} else {
			items = data ?? [];
		}
	}

	async function refreshAll() {
		if (!user || items.length === 0) return;
		refreshing = true;
		error = '';

		try {
			const { fetchListingById } = await import('$lib/listing-lookup');

			for (const item of items) {
				const match = await fetchListingById(item.boattrader_id);

				const newPrice = match?.priceUSD ?? null;
				const priceChanged =
					newPrice !== null && item.last_asking_price !== null && newPrice !== item.last_asking_price;

				// Record price snapshot
				await supabase.from('price_history').insert({
					watchlist_id: item.id,
					asking_price: newPrice,
					status: match ? 'active' : 'not_found'
				});

				// Update watchlist item
				const updates: Record<string, unknown> = {
					last_checked_at: new Date().toISOString(),
					status: match ? (priceChanged ? 'price_changed' : 'active') : 'delisted'
				};
				if (newPrice !== null) {
					updates.last_asking_price = newPrice;
				}
				if (match) {
					updates.last_location_city = match.city || item.last_location_city;
					updates.last_location_state = match.state || item.last_location_state;
					updates.listing_url = match.url || item.listing_url;
				}

				await supabase.from('watchlist').update(updates).eq('id', item.id);
			}

			await loadWatchlist();
		} catch (e) {
			error = e instanceof Error ? e.message : 'Refresh failed';
		}

		refreshing = false;
	}

	async function removeItem(id: string) {
		await supabase.from('watchlist').delete().eq('id', id);
		items = items.filter((i) => i.id !== id);
	}

	function statusBadge(status: string): string {
		switch (status) {
			case 'active':
				return 'bg-green-50 text-green-700';
			case 'price_changed':
				return 'bg-yellow-50 text-yellow-700';
			case 'delisted':
			case 'sold':
				return 'bg-red-50 text-red-700';
			default:
				return 'bg-gray-100 text-gray-600';
		}
	}

	function statusLabel(status: string): string {
		switch (status) {
			case 'active':
				return 'Active';
			case 'price_changed':
				return 'Price Changed';
			case 'delisted':
				return 'Delisted';
			case 'sold':
				return 'Sold';
			default:
				return 'Unknown';
		}
	}

	export async function addListing(listing: BoatTraderListing) {
		if (!user) return;

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
			status: 'active',
			last_checked_at: new Date().toISOString()
		});

		if (err) {
			error = err.message;
		} else {
			// Record initial price snapshot
			const { data: newItem } = await supabase
				.from('watchlist')
				.select('*')
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

			await loadWatchlist();
		}
	}
</script>

{#if !user}
	<div class="rounded-lg border border-yellow-200 bg-yellow-50 p-6 text-center">
		<p class="text-sm text-yellow-800">Sign in to save listings to your watchlist.</p>
	</div>
{:else}
	<div>
		<div class="mb-4 flex items-center justify-between">
			<h2 class="text-lg font-semibold text-gray-900">
				Your Watchlist
				{#if items.length > 0}
					<span class="ml-2 text-sm font-normal text-gray-500">({items.length})</span>
				{/if}
			</h2>
			{#if items.length > 0}
				<button
					onclick={refreshAll}
					disabled={refreshing}
					class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 transition-colors"
				>
					{refreshing ? 'Checking listings...' : 'Refresh All'}
				</button>
			{/if}
		</div>

		{#if error}
			<div class="mb-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
				{error}
			</div>
		{/if}

		{#if loading}
			<div class="py-6 text-center">
				<div class="mx-auto h-6 w-6 animate-spin rounded-full border-4 border-gray-300 border-t-blue-500"></div>
			</div>
		{:else if items.length === 0}
			<div class="rounded-lg border border-gray-200 bg-gray-50 p-8 text-center">
				<p class="text-sm text-gray-500">No saved listings yet. Search for a design or paste a listing URL above.</p>
			</div>
		{:else}
			<div class="space-y-3">
				{#each items as item}
					<div class="rounded-lg border border-gray-200 bg-white p-4">
						<div class="flex items-start justify-between">
							<div>
								<div class="font-semibold text-gray-900">
									{item.year ?? ''} {item.make} {item.model}
								</div>
								<div class="mt-1 text-sm text-gray-600">
									{[item.last_location_city, item.last_location_state].filter(Boolean).join(', ')}
								</div>
								{#if item.last_checked_at}
									<div class="mt-1 text-xs text-gray-400">
										Last checked: {new Date(item.last_checked_at).toLocaleDateString()}
									</div>
								{/if}
							</div>
							<div class="flex flex-col items-end gap-2">
								{#if item.last_asking_price}
									<div class="text-lg font-bold text-blue-600">
										{formatCurrency(item.last_asking_price)}
									</div>
								{/if}
								<span class="rounded px-2 py-0.5 text-xs font-medium {statusBadge(item.status)}">
									{statusLabel(item.status)}
								</span>
							</div>
						</div>
						<div class="mt-3 flex gap-3">
							<a
								href={item.listing_url ?? `https://www.boattrader.com/boat/${item.boattrader_id}/`}
								target="_blank"
								rel="noopener noreferrer"
								class="text-xs text-blue-600 hover:text-blue-800"
							>
								View on BoatTrader
							</a>
							<button
								onclick={() => removeItem(item.id)}
								class="text-xs text-red-500 hover:text-red-700"
							>
								Remove
							</button>
						</div>
					</div>
				{/each}
			</div>
		{/if}
	</div>
{/if}
