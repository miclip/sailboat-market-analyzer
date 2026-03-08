<script lang="ts">
	import { boats } from '$lib/seed-data';
	import { computeScores } from '$lib/scoring';
	import type { Boat, BoatScores, ScoreDimension } from '$lib/types';
	import { formatLabel } from '$lib/utils';

	interface ScoredBoat {
		boat: Boat;
		scores: BoatScores;
	}

	const scoredBoats: ScoredBoat[] = boats.map((b) => ({ boat: b, scores: computeScores(b) }));

	let sortBy = $state<'name' | ScoreDimension>('name');
	let filterManufacturer = $state('all');

	const manufacturers = [...new Set(boats.map((b) => b.manufacturer))].sort();

	const scoreKey: Record<ScoreDimension, keyof BoatScores> = {
		coastal_cruising: 'score_coastal_cruising',
		bluewater: 'score_bluewater',
		pacific_ready: 'score_pacific_ready',
		singlehand: 'score_singlehand',
		liveaboard: 'score_liveaboard',
		upwind: 'score_upwind',
		downwind: 'score_downwind'
	};

	const sorted = $derived(() => {
		let items = scoredBoats;
		if (filterManufacturer !== 'all') {
			items = items.filter((s) => s.boat.manufacturer === filterManufacturer);
		}
		if (sortBy === 'name') {
			return items.toSorted((a, b) => a.boat.design_name.localeCompare(b.boat.design_name));
		}
		const key = scoreKey[sortBy];
		return items.toSorted((a, b) => (b.scores[key] as number) - (a.scores[key] as number));
	});
</script>

<div>
	<h1 class="mb-6 text-2xl font-bold text-gray-900">Browse Designs</h1>

	<div class="mb-6 flex flex-wrap gap-4">
		<select
			bind:value={sortBy}
			class="rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
		>
			<option value="name">Sort by Name</option>
			<option value="bluewater">Sort by Bluewater Score</option>
			<option value="singlehand">Sort by Singlehand Score</option>
			<option value="pacific_ready">Sort by Pacific Ready</option>
			<option value="coastal_cruising">Sort by Coastal Cruising</option>
			<option value="liveaboard">Sort by Liveaboard</option>
			<option value="upwind">Sort by Upwind</option>
			<option value="downwind">Sort by Downwind</option>
		</select>

		<select
			bind:value={filterManufacturer}
			class="rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
		>
			<option value="all">All Manufacturers</option>
			{#each manufacturers as m}
				<option value={m}>{m}</option>
			{/each}
		</select>
	</div>

	<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
		{#each sorted() as { boat, scores }}
			<a
				href="/boats/{boat.id}"
				class="rounded-lg border border-gray-200 bg-white p-5 shadow-sm hover:border-blue-300 hover:shadow transition-all"
			>
				<div class="mb-1 font-semibold text-gray-900">{boat.design_name}</div>
				<div class="mb-3 text-xs text-gray-500">
					{boat.manufacturer} &middot; {boat.year_range_start}–{boat.year_range_end}
					{#if boat.length_ft}&middot; {boat.length_ft}ft{/if}
				</div>

				<div class="space-y-1.5 text-xs">
					<div class="flex items-center gap-2">
						<span class="w-20 text-gray-500">Bluewater</span>
						<div class="h-1.5 flex-1 overflow-hidden rounded-full bg-gray-200">
							<div class="h-full rounded-full bg-blue-500" style="width: {scores.score_bluewater}%"></div>
						</div>
						<span class="w-6 text-right font-medium">{scores.score_bluewater}</span>
					</div>
					<div class="flex items-center gap-2">
						<span class="w-20 text-gray-500">Singlehand</span>
						<div class="h-1.5 flex-1 overflow-hidden rounded-full bg-gray-200">
							<div class="h-full rounded-full bg-green-500" style="width: {scores.score_singlehand}%"></div>
						</div>
						<span class="w-6 text-right font-medium">{scores.score_singlehand}</span>
					</div>
					<div class="flex items-center gap-2">
						<span class="w-20 text-gray-500">Liveaboard</span>
						<div class="h-1.5 flex-1 overflow-hidden rounded-full bg-gray-200">
							<div class="h-full rounded-full bg-purple-500" style="width: {scores.score_liveaboard}%"></div>
						</div>
						<span class="w-6 text-right font-medium">{scores.score_liveaboard}</span>
					</div>
				</div>

				{#if boat.rudder_type || boat.keel_type || boat.rig_type}
					<div class="mt-3 flex flex-wrap gap-1.5">
						{#if boat.rudder_type}
							<span class="rounded bg-gray-100 px-2 py-0.5 text-xs text-gray-600">{formatLabel(boat.rudder_type)}</span>
						{/if}
						{#if boat.keel_type}
							<span class="rounded bg-gray-100 px-2 py-0.5 text-xs text-gray-600">{formatLabel(boat.keel_type)}</span>
						{/if}
						{#if boat.rig_type}
							<span class="rounded bg-gray-100 px-2 py-0.5 text-xs text-gray-600">{formatLabel(boat.rig_type)}</span>
						{/if}
					</div>
				{/if}
			</a>
		{/each}
	</div>
</div>
