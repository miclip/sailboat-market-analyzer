<script lang="ts">
	import type { MarketSnapshot, Boat } from '$lib/types';
	import { formatCurrency } from '$lib/utils';

	interface Props {
		latest: MarketSnapshot | null;
		previous: MarketSnapshot | null;
		boat: Boat;
		totalSnapshots: number;
	}

	let { latest, previous, boat, totalSnapshots }: Props = $props();

	const pricePerFt = $derived(
		latest?.median_price && boat.length_ft ? Math.round(latest.median_price / boat.length_ft) : null
	);

	function delta(current: number | null, prev: number | null): { pct: string; dir: 'up' | 'down' | 'flat' } | null {
		if (current == null || prev == null || prev === 0) return null;
		const change = ((current - prev) / prev) * 100;
		if (Math.abs(change) < 0.5) return { pct: '0%', dir: 'flat' };
		return {
			pct: `${change > 0 ? '+' : ''}${change.toFixed(0)}%`,
			dir: change > 0 ? 'up' : 'down'
		};
	}

	const priceDelta = $derived(delta(latest?.median_price ?? null, previous?.median_price ?? null));
	const countDelta = $derived(delta(latest?.listing_count ?? null, previous?.listing_count ?? null));
</script>

{#if latest}
	<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
		<!-- Listing Count -->
		<div class="rounded-lg border border-gray-200 bg-white p-4">
			<div class="text-xs font-medium text-gray-500">Listings</div>
			<div class="mt-1 text-2xl font-bold text-gray-900">{latest.listing_count}</div>
			{#if countDelta && totalSnapshots >= 2}
				<div class="mt-1 text-xs {countDelta.dir === 'up' ? 'text-green-600' : countDelta.dir === 'down' ? 'text-red-500' : 'text-gray-400'}">
					{countDelta.dir === 'up' ? '\u2191' : countDelta.dir === 'down' ? '\u2193' : '\u2192'} {countDelta.pct} vs prev
				</div>
			{/if}
		</div>

		<!-- Median Price -->
		<div class="rounded-lg border border-gray-200 bg-white p-4">
			<div class="text-xs font-medium text-gray-500">Median Price</div>
			<div class="mt-1 text-2xl font-bold text-blue-600">
				{latest.median_price != null ? formatCurrency(latest.median_price) : '—'}
			</div>
			{#if priceDelta && totalSnapshots >= 2}
				<div class="mt-1 text-xs {priceDelta.dir === 'down' ? 'text-green-600' : priceDelta.dir === 'up' ? 'text-red-500' : 'text-gray-400'}">
					{priceDelta.dir === 'up' ? '\u2191' : priceDelta.dir === 'down' ? '\u2193' : '\u2192'} {priceDelta.pct} vs prev
				</div>
			{/if}
		</div>

		<!-- Price Range -->
		<div class="rounded-lg border border-gray-200 bg-white p-4">
			<div class="text-xs font-medium text-gray-500">Price Range</div>
			{#if latest.min_price != null && latest.max_price != null}
				<div class="mt-1 text-lg font-bold text-gray-900">
					{formatCurrency(latest.min_price)} – {formatCurrency(latest.max_price)}
				</div>
			{:else}
				<div class="mt-1 text-lg font-bold text-gray-400">—</div>
			{/if}
		</div>

		<!-- Price Per Foot -->
		<div class="rounded-lg border border-gray-200 bg-white p-4">
			<div class="text-xs font-medium text-gray-500">Price / Foot</div>
			<div class="mt-1 text-2xl font-bold text-gray-900">
				{pricePerFt != null ? formatCurrency(pricePerFt) : '—'}
			</div>
			{#if boat.length_ft}
				<div class="mt-1 text-xs text-gray-400">based on {boat.length_ft}ft LOA</div>
			{/if}
		</div>
	</div>

	<div class="mt-2 text-xs text-gray-400">
		as of {new Date(latest.snapshot_date).toLocaleDateString()}
		{#if totalSnapshots > 1}
			&middot; {totalSnapshots} snapshots collected
		{/if}
	</div>
{:else}
	<div class="rounded-lg border border-dashed border-gray-300 bg-gray-50 p-6 text-center">
		<p class="text-sm text-gray-500">No market data yet.</p>
		<p class="mt-1 text-xs text-gray-400">Search BoatTrader listings below to start collecting price data.</p>
	</div>
{/if}
