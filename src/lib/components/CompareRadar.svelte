<script lang="ts">
	import type { BoatScores } from '$lib/types';

	interface CompareEntry {
		name: string;
		scores: BoatScores;
		color: string;
		fill: string;
	}

	interface Props {
		entries: CompareEntry[];
		size?: number;
	}

	let { entries, size = 400 }: Props = $props();

	const dimensions = [
		{ key: 'score_coastal_cruising', label: 'Coastal' },
		{ key: 'score_bluewater', label: 'Bluewater' },
		{ key: 'score_pacific_ready', label: 'Pacific' },
		{ key: 'score_singlehand', label: 'Singlehand' },
		{ key: 'score_liveaboard', label: 'Liveaboard' },
		{ key: 'score_upwind', label: 'Upwind' },
		{ key: 'score_downwind', label: 'Downwind' }
	] as const;

	const cx = $derived(size / 2);
	const cy = $derived(size / 2);
	const radius = $derived(size / 2 - 50);

	function getPoint(index: number, value: number): { x: number; y: number } {
		const angle = (Math.PI * 2 * index) / dimensions.length - Math.PI / 2;
		const r = (value / 100) * radius;
		return {
			x: cx + r * Math.cos(angle),
			y: cy + r * Math.sin(angle)
		};
	}

	const gridLevels = [25, 50, 75, 100];
</script>

<div>
	<svg width={size} height={size} viewBox="0 0 {size} {size}" class="mx-auto">
		<!-- Grid circles -->
		{#each gridLevels as level}
			{@const r = (level / 100) * radius}
			<circle {cx} {cy} r={r} fill="none" stroke="#e5e7eb" stroke-width="1" />
			{#if level === 50 || level === 100}
				<text
					x={cx + 4}
					y={cy - r + 2}
					class="fill-gray-300 text-[9px]"
					dominant-baseline="auto"
				>
					{level}
				</text>
			{/if}
		{/each}

		<!-- Axis lines -->
		{#each dimensions as _, i}
			{@const point = getPoint(i, 100)}
			<line x1={cx} y1={cy} x2={point.x} y2={point.y} stroke="#e5e7eb" stroke-width="1" />
		{/each}

		<!-- Data polygons (one per entry) -->
		{#each entries as entry}
			{@const points = dimensions.map((d, i) =>
				getPoint(i, entry.scores[d.key as keyof BoatScores] as number)
			)}
			{@const polygonStr = points.map((p) => `${p.x},${p.y}`).join(' ')}
			<polygon points={polygonStr} fill={entry.fill} stroke={entry.color} stroke-width="2.5" />
		{/each}

		<!-- Data points -->
		{#each entries as entry}
			{#each dimensions as dim, i}
				{@const point = getPoint(i, entry.scores[dim.key as keyof BoatScores] as number)}
				<circle cx={point.x} cy={point.y} r="3.5" fill={entry.color} stroke="white" stroke-width="1" />
			{/each}
		{/each}

		<!-- Dimension labels -->
		{#each dimensions as dim, i}
			{@const labelPoint = getPoint(i, 118)}
			<text
				x={labelPoint.x}
				y={labelPoint.y}
				text-anchor="middle"
				dominant-baseline="middle"
				class="fill-gray-600 text-xs font-medium"
			>
				{dim.label}
			</text>
		{/each}
	</svg>

	<!-- Legend -->
	<div class="mt-2 flex flex-wrap justify-center gap-4">
		{#each entries as entry}
			<div class="flex items-center gap-1.5">
				<span class="inline-block h-3 w-3 rounded-full" style="background-color: {entry.color}"></span>
				<span class="text-sm text-gray-700">{entry.name}</span>
			</div>
		{/each}
	</div>
</div>
