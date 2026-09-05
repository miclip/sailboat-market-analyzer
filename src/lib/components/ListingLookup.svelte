<script lang="ts">
	import { isListingsUnavailable, type BoatTraderListing } from '$lib/boattrader';
	import { formatCurrency, formatNumber } from '$lib/utils';

	interface Props {
		onsave: (listing: BoatTraderListing) => void;
	}

	let { onsave }: Props = $props();

	let url = $state('');
	let loading = $state(false);
	let error = $state('');
	let unavailable = $state('');
	let listing = $state<BoatTraderListing | null>(null);

	async function handleLookup() {
		if (!url.trim()) return;

		loading = true;
		error = '';
		unavailable = '';
		listing = null;

		try {
			// Dynamic import to avoid loading listing-lookup on server
			const { extractListingId, fetchListingById, isBoatListingUrl } = await import(
				'$lib/listing-lookup'
			);

			if (!isBoatListingUrl(url)) {
				error = 'Please paste a YachtWorld or BoatTrader URL.';
				loading = false;
				return;
			}

			const id = extractListingId(url);
			if (!id) {
				error = 'Could not extract listing ID from URL.';
				loading = false;
				return;
			}

			const result = await fetchListingById(id);
			if (!result) {
				error = 'Listing not found. It may have been removed.';
			} else {
				listing = result;
			}
		} catch (e) {
			if (isListingsUnavailable(e)) {
				unavailable = e.message;
			} else {
				error = e instanceof Error ? e.message : 'Failed to fetch listing';
			}
		}

		loading = false;
	}
</script>

<div class="space-y-4">
	<div>
		<label for="listing-url" class="mb-1 block text-sm font-medium text-gray-700">
			Paste a YachtWorld or BoatTrader listing URL
		</label>
		<div class="flex gap-2">
			<input
				id="listing-url"
				type="url"
				bind:value={url}
				placeholder="https://www.yachtworld.com/yacht/..."
				class="flex-1 rounded-lg border border-gray-300 px-4 py-2.5 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500 focus:outline-none"
			/>
			<button
				onclick={handleLookup}
				disabled={loading || !url.trim()}
				class="rounded-lg bg-blue-600 px-5 py-2.5 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50 transition-colors"
			>
				{loading ? 'Looking up...' : 'Look Up'}
			</button>
		</div>
	</div>

	{#if error}
		<div class="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
			{error}
		</div>
	{/if}

	{#if unavailable}
		<div class="rounded-lg border border-amber-200 bg-amber-50 px-4 py-4">
			<p class="text-sm font-medium text-amber-900">Lookup unavailable</p>
			<p class="mt-1 text-sm text-amber-800">
				{unavailable} You can still add this boat by hand — open the listing, then use the
				submit form to enter its details.
			</p>
			<a
				href="/listings/submit"
				class="mt-3 inline-block text-sm font-medium text-amber-900 underline hover:text-amber-700"
			>
				Enter listing details manually
			</a>
		</div>
	{/if}

	{#if listing}
		<div class="rounded-lg border border-gray-200 bg-white p-5">
			<div class="flex items-start justify-between">
				<div>
					<div class="text-lg font-semibold text-gray-900">
						{listing.year} {listing.make} {listing.model}
					</div>
					<div class="mt-1 text-sm text-gray-600">
						{[listing.city, listing.state].filter(Boolean).join(', ')}
					</div>
					<div class="mt-2 flex flex-wrap gap-3 text-xs text-gray-500">
						{#if listing.lengthFt}
							<span>LOA: {listing.lengthFt}ft</span>
						{/if}
						{#if listing.beamFt}
							<span>Beam: {listing.beamFt}ft</span>
						{/if}
						{#if listing.displacementLbs}
							<span>Disp: {formatNumber(listing.displacementLbs)}lbs</span>
						{/if}
						{#if listing.cabins}
							<span>{listing.cabins} cabin{listing.cabins !== 1 ? 's' : ''}</span>
						{/if}
					</div>
				</div>
				<div class="text-right">
					{#if listing.priceUSD && !listing.priceHidden}
						<div class="text-xl font-bold text-blue-600">{formatCurrency(listing.priceUSD)}</div>
					{:else}
						<div class="text-sm text-gray-400">Contact for price</div>
					{/if}
				</div>
			</div>
			<div class="mt-4 flex gap-3">
				<button
					onclick={() => listing && onsave(listing)}
					class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
				>
					Save to Watchlist
				</button>
				<a
					href={listing.url}
					target="_blank"
					rel="noopener noreferrer"
					class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors"
				>
					View on BoatTrader
				</a>
			</div>
		</div>
	{/if}
</div>
