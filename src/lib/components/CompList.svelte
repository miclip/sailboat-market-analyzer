<script lang="ts">
	import type { Listing, Comp } from '$lib/types';
	import type { CompScore } from '$lib/comp-finder';
	import { formatCurrency, formatLabel } from '$lib/utils';

	interface Props {
		compScores: CompScore[];
		reportedComps?: (Comp & { listing?: Listing })[];
	}

	let { compScores, reportedComps = [] }: Props = $props();
</script>

<div class="space-y-6">
	{#if compScores.length > 0}
		<div>
			<h3 class="mb-3 text-sm font-semibold text-gray-900">Inferred Price Ranges</h3>
			<div class="space-y-3">
				{#each compScores as comp}
					{@const listing = comp.listing}
					<div class="rounded-lg border border-gray-200 bg-white p-4">
						<div class="flex items-start justify-between">
							<div>
								<div class="text-sm font-medium text-gray-900">
									{#if listing.asking_price}
										{formatCurrency(listing.asking_price)} asking
									{:else}
										Price unknown
									{/if}
								</div>
								<div class="mt-1 text-xs text-gray-500">
									{[listing.location_city, listing.location_state].filter(Boolean).join(', ') || 'Location unknown'}
									{#if listing.location_market}
										&middot; {formatLabel(listing.location_market)}
									{/if}
								</div>
								{#if listing.condition_tier}
									<div class="mt-1 text-xs text-gray-500">
										Condition: {formatLabel(listing.condition_tier)}
										{#if listing.engine_hours != null}
											&middot; {listing.engine_hours} engine hrs
										{/if}
									</div>
								{/if}
								{#if listing.list_date}
									<div class="mt-1 text-xs text-gray-400">
										Listed: {listing.list_date}
										{#if listing.days_on_market != null}
											&middot; {listing.days_on_market} days on market
										{/if}
									</div>
								{/if}
							</div>
							<div class="text-right">
								<div class="rounded bg-blue-50 px-2 py-1 text-xs font-medium text-blue-700">
									Match: {comp.score}%
								</div>
								{#if comp.inferred}
									<div class="mt-2 text-sm font-medium text-gray-900">
										{formatCurrency(comp.inferred.low)} – {formatCurrency(comp.inferred.high)}
									</div>
									<div class="text-xs text-gray-500">
										{comp.inferred.confidence} confidence
									</div>
								{/if}
							</div>
						</div>
						{#if comp.inferred}
							<div class="mt-2 text-xs text-gray-400">{comp.inferred.method}</div>
						{/if}
					</div>
				{/each}
			</div>
		</div>
	{/if}

	{#if reportedComps.length > 0}
		<div>
			<h3 class="mb-3 text-sm font-semibold text-gray-900">Reported Sale Prices</h3>
			<div class="space-y-3">
				{#each reportedComps as comp}
					<div class="rounded-lg border border-gray-200 bg-white p-4">
						<div class="flex items-start justify-between">
							<div>
								{#if comp.reported_sale_price}
									<div class="text-sm font-medium text-gray-900">
										{formatCurrency(comp.reported_sale_price)}
									</div>
								{/if}
								{#if comp.sale_date}
									<div class="mt-1 text-xs text-gray-500">Sold: {comp.sale_date}</div>
								{/if}
								{#if comp.reporter_role}
									<div class="mt-1 text-xs text-gray-500">
										Reported by: {formatLabel(comp.reporter_role)}
									</div>
								{/if}
								{#if comp.notes}
									<div class="mt-1 text-xs text-gray-500">{comp.notes}</div>
								{/if}
							</div>
							<div class="text-right">
								{#if comp.verified}
									<span class="rounded bg-green-50 px-2 py-0.5 text-xs font-medium text-green-700">Verified</span>
								{/if}
								<div class="mt-1 text-xs text-gray-400">
									Confidence: {comp.confidence_score}%
								</div>
							</div>
						</div>
					</div>
				{/each}
			</div>
		</div>
	{/if}

	{#if compScores.length === 0 && reportedComps.length === 0}
		<div class="rounded-lg border border-gray-200 bg-gray-50 p-6 text-center text-sm text-gray-500">
			No comparable sales data yet. Be the first to submit a listing for this design.
		</div>
	{/if}
</div>
