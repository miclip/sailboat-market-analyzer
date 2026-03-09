<script lang="ts">
	import type { BoatScores, ScoreDimension } from '$lib/types';
	import { formatLabel } from '$lib/utils';

	interface Props {
		scores: BoatScores;
		initialDimension?: ScoreDimension;
	}

	let { scores, initialDimension }: Props = $props();

	let selectedDimension = $state<ScoreDimension>('bluewater');
	$effect(() => {
		if (initialDimension) selectedDimension = initialDimension;
	});

	const dimensionOptions: { key: ScoreDimension; label: string; score: number }[] = $derived([
		{ key: 'coastal_cruising', label: 'Coastal Cruising', score: scores.score_coastal_cruising },
		{ key: 'bluewater', label: 'Bluewater', score: scores.score_bluewater },
		{ key: 'singlehand', label: 'Singlehand', score: scores.score_singlehand },
		{ key: 'liveaboard', label: 'Liveaboard', score: scores.score_liveaboard },
		{ key: 'upwind', label: 'Upwind', score: scores.score_upwind },
		{ key: 'downwind', label: 'Downwind', score: scores.score_downwind }
	]);

	const breakdownItems = $derived(scores.score_breakdown?.[selectedDimension] ?? []);

	function scoreColor(score: number): string {
		if (score >= 80) return 'bg-green-500';
		if (score >= 60) return 'bg-blue-500';
		if (score >= 40) return 'bg-yellow-500';
		return 'bg-red-500';
	}
</script>

<div>
	<div class="mb-4 flex flex-wrap gap-2">
		{#each dimensionOptions as dim}
			<button
				class="rounded-full px-3 py-1 text-sm font-medium transition-colors {selectedDimension === dim.key
					? 'bg-blue-600 text-white'
					: 'bg-gray-100 text-gray-700 hover:bg-gray-200'}"
				onclick={() => (selectedDimension = dim.key)}
			>
				{dim.label}
				<span class="ml-1 opacity-70">{dim.score}</span>
			</button>
		{/each}
	</div>

	{#if breakdownItems.length > 0}
		<div class="space-y-3">
			{#each breakdownItems as item}
				<div>
					<div class="mb-1 flex items-center justify-between text-sm">
						<span class="font-medium text-gray-700">{item.factor}</span>
						<span class="text-gray-500">
							{formatLabel(item.value)} &middot; {(item.weight * 100).toFixed(0)}% weight &middot;
							{item.points} pts
						</span>
					</div>
					<div class="h-2 overflow-hidden rounded-full bg-gray-200">
						<div
							class="h-full rounded-full transition-all {scoreColor(item.points)}"
							style="width: {item.points}%"
						></div>
					</div>
				</div>
			{/each}
		</div>
	{:else}
		<p class="text-sm text-gray-500">No breakdown data available.</p>
	{/if}
</div>
