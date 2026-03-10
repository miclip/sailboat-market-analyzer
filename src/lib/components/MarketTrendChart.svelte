<script lang="ts">
	import type { MarketSnapshot } from '$lib/types';
	import { formatCurrency } from '$lib/utils';

	interface Props {
		snapshots: MarketSnapshot[];
	}

	let { snapshots }: Props = $props();

	const width = 600;
	const height = 260;
	const pad = { top: 20, right: 20, bottom: 30, left: 65 };
	const chartW = width - pad.left - pad.right;
	const chartH = height - pad.top - pad.bottom;

	// Sort ascending by date
	const sorted = $derived(
		[...snapshots]
			.filter((s) => s.median_price != null)
			.sort((a, b) => a.snapshot_date.localeCompare(b.snapshot_date))
	);

	// Price range across all snapshots
	const allPrices = $derived(
		sorted.flatMap((s) => [s.min_price, s.max_price, s.median_price].filter((p): p is number => p != null))
	);
	const priceMin = $derived(allPrices.length > 0 ? Math.min(...allPrices) * 0.9 : 0);
	const priceMax = $derived(allPrices.length > 0 ? Math.max(...allPrices) * 1.1 : 100000);

	// Date range
	const dateMin = $derived(sorted.length > 0 ? new Date(sorted[0].snapshot_date).getTime() : 0);
	const dateMax = $derived(
		sorted.length > 1
			? new Date(sorted[sorted.length - 1].snapshot_date).getTime()
			: dateMin + 86400000
	);

	function x(date: string): number {
		const t = dateMax > dateMin ? (new Date(date).getTime() - dateMin) / (dateMax - dateMin) : 0.5;
		return pad.left + t * chartW;
	}

	function y(price: number): number {
		const t = priceMax > priceMin ? (price - priceMin) / (priceMax - priceMin) : 0.5;
		return pad.top + chartH - t * chartH;
	}

	// SVG paths
	const medianPath = $derived(
		sorted.map((s, i) => `${i === 0 ? 'M' : 'L'}${x(s.snapshot_date)},${y(s.median_price!)}`).join(' ')
	);

	const bandPath = $derived(() => {
		if (sorted.length < 2) return '';
		const top = sorted.map((s) => `${x(s.snapshot_date)},${y(s.max_price ?? s.median_price!)}`);
		const bottom = [...sorted].reverse().map((s) => `${x(s.snapshot_date)},${y(s.min_price ?? s.median_price!)}`);
		return `M${top.join(' L')} L${bottom.join(' L')} Z`;
	});

	// Y-axis ticks (4-5 ticks)
	const yTicks = $derived(() => {
		const range = priceMax - priceMin;
		const step = Math.ceil(range / 4 / 10000) * 10000;
		const ticks: number[] = [];
		let v = Math.ceil(priceMin / step) * step;
		while (v <= priceMax) {
			ticks.push(v);
			v += step;
		}
		return ticks;
	});

	// X-axis labels
	const xLabels = $derived(
		sorted.map((s) => ({
			date: s.snapshot_date,
			label: new Date(s.snapshot_date).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
		}))
	);

	// Hover state
	let hoveredIdx = $state<number | null>(null);
	const hovered = $derived(hoveredIdx != null ? sorted[hoveredIdx] : null);

	function handleMouseMove(e: MouseEvent) {
		const svg = (e.currentTarget as SVGSVGElement).getBoundingClientRect();
		const mx = ((e.clientX - svg.left) / svg.width) * width;
		if (mx < pad.left || mx > width - pad.right || sorted.length === 0) {
			hoveredIdx = null;
			return;
		}
		// Find closest point
		let closest = 0;
		let closestDist = Infinity;
		for (let i = 0; i < sorted.length; i++) {
			const px = x(sorted[i].snapshot_date);
			const dist = Math.abs(px - mx);
			if (dist < closestDist) {
				closestDist = dist;
				closest = i;
			}
		}
		hoveredIdx = closest;
	}
</script>

{#if sorted.length === 0}
	<p class="py-4 text-center text-sm text-gray-400">No price data yet.</p>
{:else if sorted.length === 1}
	<div class="flex items-center gap-6 py-4">
		<div>
			<div class="text-2xl font-bold text-blue-600">{formatCurrency(sorted[0].median_price!)}</div>
			<div class="text-xs text-gray-500">Median on {new Date(sorted[0].snapshot_date).toLocaleDateString()}</div>
		</div>
		{#if sorted[0].min_price != null && sorted[0].max_price != null && sorted[0].min_price !== sorted[0].max_price}
			<div class="text-sm text-gray-500">
				Range: {formatCurrency(sorted[0].min_price)} – {formatCurrency(sorted[0].max_price)}
			</div>
		{/if}
		<div class="text-xs text-gray-400">Chart appears after 2+ snapshots</div>
	</div>
{:else}
	<!-- svelte-ignore a11y_no_static_element_interactions -->
	<div class="relative">
		<svg
			viewBox="0 0 {width} {height}"
			class="w-full"
			preserveAspectRatio="xMidYMid meet"
			onmousemove={handleMouseMove}
			onmouseleave={() => (hoveredIdx = null)}
		>
			<!-- Y grid lines and labels -->
			{#each yTicks() as tick}
				<line
					x1={pad.left}
					y1={y(tick)}
					x2={width - pad.right}
					y2={y(tick)}
					stroke="#e5e7eb"
					stroke-width="1"
				/>
				<text
					x={pad.left - 8}
					y={y(tick)}
					text-anchor="end"
					dominant-baseline="middle"
					class="fill-gray-400 text-[10px]"
				>
					{formatCurrency(tick)}
				</text>
			{/each}

			<!-- Min/max band -->
			{#if bandPath()}
				<path d={bandPath()} fill="rgba(59, 130, 246, 0.08)" />
			{/if}

			<!-- Median line -->
			<path d={medianPath} fill="none" stroke="#3b82f6" stroke-width="2.5" stroke-linejoin="round" />

			<!-- Data points -->
			{#each sorted as s, i}
				<circle
					cx={x(s.snapshot_date)}
					cy={y(s.median_price!)}
					r={hoveredIdx === i ? 5 : 3}
					fill={hoveredIdx === i ? '#2563eb' : '#3b82f6'}
					stroke="white"
					stroke-width="1.5"
				/>
			{/each}

			<!-- X-axis labels (show up to 8 evenly spaced) -->
			{#each xLabels as xl, i}
				{#if i % Math.max(1, Math.floor(xLabels.length / 8)) === 0 || i === xLabels.length - 1}
					<text
						x={x(xl.date)}
						y={height - 6}
						text-anchor="middle"
						class="fill-gray-400 text-[10px]"
					>
						{xl.label}
					</text>
				{/if}
			{/each}

			<!-- Hover crosshair -->
			{#if hovered}
				<line
					x1={x(hovered.snapshot_date)}
					y1={pad.top}
					x2={x(hovered.snapshot_date)}
					y2={pad.top + chartH}
					stroke="#9ca3af"
					stroke-width="1"
					stroke-dasharray="4 2"
				/>
			{/if}
		</svg>

		<!-- Tooltip -->
		{#if hovered}
			{@const tx = x(hovered.snapshot_date)}
			<div
				class="pointer-events-none absolute top-0 z-10 rounded-lg border border-gray-200 bg-white px-3 py-2 text-xs shadow-md"
				style="left: {(tx / width) * 100}%; transform: translateX({tx > width / 2 ? '-100%' : '0'})"
			>
				<div class="font-medium text-gray-900">
					{new Date(hovered.snapshot_date).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}
				</div>
				{#if hovered.median_price != null}
					<div class="text-blue-600">Median: {formatCurrency(hovered.median_price)}</div>
				{/if}
				{#if hovered.min_price != null && hovered.max_price != null}
					<div class="text-gray-500">Range: {formatCurrency(hovered.min_price)} – {formatCurrency(hovered.max_price)}</div>
				{/if}
				<div class="text-gray-500">{hovered.listing_count} listing{hovered.listing_count !== 1 ? 's' : ''}</div>
			</div>
		{/if}
	</div>
{/if}
