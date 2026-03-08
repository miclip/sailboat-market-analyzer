<script lang="ts">
	import type { BoatScores } from '$lib/types';

	interface Props {
		scores: BoatScores;
		size?: number;
	}

	let { scores, size = 300 }: Props = $props();

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
	const radius = $derived(size / 2 - 40);

	function getPoint(index: number, value: number): { x: number; y: number } {
		const angle = (Math.PI * 2 * index) / dimensions.length - Math.PI / 2;
		const r = (value / 100) * radius;
		return {
			x: cx + r * Math.cos(angle),
			y: cy + r * Math.sin(angle)
		};
	}

	const dataPoints = $derived(
		dimensions.map((d, i) => getPoint(i, scores[d.key as keyof BoatScores] as number))
	);

	const polygonPoints = $derived(dataPoints.map((p) => `${p.x},${p.y}`).join(' '));

	const gridLevels = [25, 50, 75, 100];
</script>

<svg width={size} height={size} viewBox="0 0 {size} {size}" class="mx-auto">
	<!-- Grid circles -->
	{#each gridLevels as level}
		{@const r = (level / 100) * radius}
		<circle {cx} {cy} r={r} fill="none" stroke="#e5e7eb" stroke-width="1" />
	{/each}

	<!-- Axis lines -->
	{#each dimensions as _, i}
		{@const point = getPoint(i, 100)}
		<line x1={cx} y1={cy} x2={point.x} y2={point.y} stroke="#e5e7eb" stroke-width="1" />
	{/each}

	<!-- Data polygon -->
	<polygon points={polygonPoints} fill="rgba(59, 130, 246, 0.2)" stroke="#3b82f6" stroke-width="2" />

	<!-- Data points -->
	{#each dataPoints as point}
		<circle cx={point.x} cy={point.y} r="4" fill="#3b82f6" />
	{/each}

	<!-- Labels -->
	{#each dimensions as dim, i}
		{@const labelPoint = getPoint(i, 120)}
		{@const score = scores[dim.key as keyof BoatScores] as number}
		<text
			x={labelPoint.x}
			y={labelPoint.y}
			text-anchor="middle"
			dominant-baseline="middle"
			class="fill-gray-700 text-xs font-medium"
		>
			{dim.label}
		</text>
		<text
			x={labelPoint.x}
			y={labelPoint.y + 14}
			text-anchor="middle"
			dominant-baseline="middle"
			class="fill-gray-500 text-xs"
		>
			{score}
		</text>
	{/each}
</svg>
