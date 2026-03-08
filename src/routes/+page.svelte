<script lang="ts">
	import { goto } from '$app/navigation';
	import { boats } from '$lib/seed-data';
	import { computeScores } from '$lib/scoring';
	import type { Boat, BoatScores } from '$lib/types';
	import BoatSearch from '$lib/components/BoatSearch.svelte';

	interface ScoredBoat {
		boat: Boat;
		scores: BoatScores;
	}

	const scoredBoats: ScoredBoat[] = boats.map((b) => ({ boat: b, scores: computeScores(b) }));

	const topBluewater = scoredBoats.toSorted((a, b) => b.scores.score_bluewater - a.scores.score_bluewater).slice(0, 5);
	const topSinglehand = scoredBoats.toSorted((a, b) => b.scores.score_singlehand - a.scores.score_singlehand).slice(0, 5);
	const topPacific = scoredBoats.toSorted((a, b) => b.scores.score_pacific_ready - a.scores.score_pacific_ready).slice(0, 5);

	function handleSelect(boat: Boat) {
		goto(`/boats/${boat.id}`);
	}
</script>

<div class="space-y-10">
	<section class="text-center">
		<h1 class="mb-2 text-3xl font-bold text-gray-900">Find Your Bluewater Boat</h1>
		<p class="mx-auto mb-6 max-w-xl text-gray-600">
			Evaluate offshore sailing vessels by the structural design characteristics that actually
			matter for ocean passagemaking.
		</p>
		<div class="mx-auto max-w-lg">
			<BoatSearch {boats} onselect={handleSelect} />
		</div>
	</section>

	<section>
		<h2 class="mb-4 text-xl font-semibold text-gray-900">Top Bluewater Designs</h2>
		<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-5">
			{#each topBluewater as { boat, scores }}
				<a
					href="/boats/{boat.id}"
					class="rounded-lg border border-gray-200 bg-white p-4 shadow-sm hover:border-blue-300 hover:shadow transition-all"
				>
					<div class="text-sm font-semibold text-gray-900">{boat.design_name}</div>
					<div class="text-xs text-gray-500">{boat.manufacturer}</div>
					<div class="mt-2 flex items-center gap-2">
						<div class="h-2 flex-1 overflow-hidden rounded-full bg-gray-200">
							<div
								class="h-full rounded-full bg-blue-500"
								style="width: {scores.score_bluewater}%"
							></div>
						</div>
						<span class="text-xs font-medium text-blue-600">{scores.score_bluewater}</span>
					</div>
				</a>
			{/each}
		</div>
	</section>

	<section>
		<h2 class="mb-4 text-xl font-semibold text-gray-900">Top Singlehand Designs</h2>
		<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-5">
			{#each topSinglehand as { boat, scores }}
				<a
					href="/boats/{boat.id}"
					class="rounded-lg border border-gray-200 bg-white p-4 shadow-sm hover:border-blue-300 hover:shadow transition-all"
				>
					<div class="text-sm font-semibold text-gray-900">{boat.design_name}</div>
					<div class="text-xs text-gray-500">{boat.manufacturer}</div>
					<div class="mt-2 flex items-center gap-2">
						<div class="h-2 flex-1 overflow-hidden rounded-full bg-gray-200">
							<div
								class="h-full rounded-full bg-green-500"
								style="width: {scores.score_singlehand}%"
							></div>
						</div>
						<span class="text-xs font-medium text-green-600">{scores.score_singlehand}</span>
					</div>
				</a>
			{/each}
		</div>
	</section>

	<section>
		<h2 class="mb-4 text-xl font-semibold text-gray-900">Top Pacific-Ready Designs</h2>
		<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-5">
			{#each topPacific as { boat, scores }}
				<a
					href="/boats/{boat.id}"
					class="rounded-lg border border-gray-200 bg-white p-4 shadow-sm hover:border-blue-300 hover:shadow transition-all"
				>
					<div class="text-sm font-semibold text-gray-900">{boat.design_name}</div>
					<div class="text-xs text-gray-500">{boat.manufacturer}</div>
					<div class="mt-2 flex items-center gap-2">
						<div class="h-2 flex-1 overflow-hidden rounded-full bg-gray-200">
							<div
								class="h-full rounded-full bg-purple-500"
								style="width: {scores.score_pacific_ready}%"
							></div>
						</div>
						<span class="text-xs font-medium text-purple-600">{scores.score_pacific_ready}</span>
					</div>
				</a>
			{/each}
		</div>
	</section>

	<section class="text-center">
		<a
			href="/boats"
			class="inline-block rounded-lg bg-gray-900 px-6 py-3 text-sm font-medium text-white hover:bg-gray-800 transition-colors"
		>
			Browse All {boats.length} Designs
		</a>
	</section>
</div>
