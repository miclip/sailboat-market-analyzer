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
	let loading = $state(true);
	let error = $state('');

	$effect(() => {
		// Read props synchronously so Svelte tracks them as dependencies
		const m = make;
		const mod = model;
		loadListings(m, mod);
	});

	async function loadListings(m: string, mod?: string) {
		loading = true;
		error = '';
		try {
			const result = await searchListings(m, mod);
			listings = result.listings;
			total = result.total;
		} catch (e) {
			error = e instanceof Error ? e.message : 'Failed to fetch listings';
		}
		loading = false;
	}
</script>

<div>
	{#if loading}
		<div class="py-6 text-center">
			<div class="mx-auto h-6 w-6 animate-spin rounded-full border-4 border-gray-300 border-t-blue-500"></div>
			<p class="mt-2 text-sm text-gray-500">Searching BoatTrader...</p>
		</div>
	{:else if error}
		<div class="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{error}</div>
	{:else if listings.length === 0}
		<p class="text-sm text-gray-500">No listings found on BoatTrader for {make} {model ?? ''}.</p>
	{:else}
		<p class="mb-4 text-sm text-gray-500">{total} listing{total !== 1 ? 's' : ''} found on BoatTrader</p>
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
