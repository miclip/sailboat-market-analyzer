<script lang="ts">
	import { searchListings, type BoatTraderListing } from '$lib/boattrader';
	import { formatCurrency, formatNumber } from '$lib/utils';

	interface Props {
		make: string;
		model?: string;
	}

	let { make, model }: Props = $props();

	let listings = $state<BoatTraderListing[]>([]);
	let total = $state(0);
	let loading = $state(false);
	let searched = $state(false);
	let error = $state('');

	async function handleSearch() {
		loading = true;
		error = '';
		try {
			const result = await searchListings(make, model);
			listings = result.listings;
			total = result.total;
		} catch (e) {
			error = e instanceof Error ? e.message : 'Failed to fetch listings';
		}
		loading = false;
		searched = true;
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
				<a
					href={listing.url}
					target="_blank"
					rel="noopener noreferrer"
					class="block rounded-lg border border-gray-200 bg-white p-4 hover:border-blue-300 hover:shadow transition-all"
				>
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
							</div>
						</div>
						<div class="text-right">
							{#if listing.priceUSD && !listing.priceHidden}
								<div class="text-lg font-bold text-blue-600">{formatCurrency(listing.priceUSD)}</div>
							{:else}
								<div class="text-sm text-gray-400">Contact for price</div>
							{/if}
							<div class="mt-1 text-xs text-blue-500">View on BoatTrader</div>
						</div>
					</div>
				</a>
			{/each}
		</div>
	{/if}
</div>
