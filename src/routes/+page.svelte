<script lang="ts">
	import { goto } from '$app/navigation';
	import { boats } from '$lib/seed-data';
	import { computeScores } from '$lib/scoring';
	import type { Boat, BoatScores, ScoreDimension } from '$lib/types';
	import type { BoatTraderListing } from '$lib/boattrader';
	import UseCaseForm from '$lib/components/UseCaseForm.svelte';
	import ListingLookup from '$lib/components/ListingLookup.svelte';
	import Watchlist from '$lib/components/Watchlist.svelte';
	import { getUser } from '$lib/auth.svelte';
	import { formatLabel } from '$lib/utils';

	interface ScoredBoat {
		boat: Boat;
		scores: BoatScores;
	}

	const scoredBoats: ScoredBoat[] = boats.map((b) => ({ boat: b, scores: computeScores(b) }));

	let step = $state(1);
	let useCase = $state('');
	let experience = $state('');
	let waters = $state('');

	let watchlistRef = $state<Watchlist>();

	const user = $derived(getUser());

	// Map use case to primary score dimension
	const useCaseToScore: Record<string, keyof BoatScores> = {
		bluewater: 'score_bluewater',
		pacific: 'score_pacific_ready',
		coastal: 'score_coastal_cruising',
		liveaboard: 'score_liveaboard',
		singlehand: 'score_singlehand',
		circumnavigation: 'score_pacific_ready'
	};

	const rankedDesigns = $derived(() => {
		const key = useCaseToScore[useCase] ?? 'score_bluewater';
		return scoredBoats
			.toSorted((a, b) => (b.scores[key] as number) - (a.scores[key] as number));
	});

	function handleUseCaseSubmit(uc: string, exp: string, w: string) {
		useCase = uc;
		experience = exp;
		waters = w;
		step = 2;
	}

	function handleSaveListing(listing: BoatTraderListing) {
		watchlistRef?.addListing(listing);
	}

	const steps = [
		{ num: 1, label: 'Use Case' },
		{ num: 2, label: 'Designs' },
		{ num: 3, label: 'Find a Boat' }
	];
</script>

<div class="space-y-8">
	<!-- Step indicator -->
	<div class="flex items-center justify-center gap-2">
		{#each steps as s}
			<button
				onclick={() => { if (s.num <= step || (s.num === 2 && useCase) || (s.num === 3 && useCase)) step = s.num; }}
				class="flex items-center gap-2 rounded-full px-4 py-2 text-sm font-medium transition-all
					{step === s.num
					? 'bg-blue-600 text-white'
					: step > s.num
						? 'bg-blue-100 text-blue-700 hover:bg-blue-200'
						: 'bg-gray-100 text-gray-400'}"
			>
				<span class="flex h-6 w-6 items-center justify-center rounded-full text-xs
					{step === s.num
					? 'bg-blue-500 text-white'
					: step > s.num
						? 'bg-blue-200 text-blue-700'
						: 'bg-gray-200 text-gray-400'}"
				>
					{s.num}
				</span>
				{s.label}
			</button>
			{#if s.num < steps.length}
				<div class="h-px w-8 {step > s.num ? 'bg-blue-300' : 'bg-gray-200'}"></div>
			{/if}
		{/each}
	</div>

	<!-- Step 1: Use Case -->
	{#if step === 1}
		<section>
			<div class="mb-6 text-center">
				<h1 class="mb-2 text-3xl font-bold text-gray-900">Find Your Boat</h1>
				<p class="mx-auto max-w-xl text-gray-600">
					Tell us how you plan to sail and we'll rank designs by what matters for your use case.
				</p>
			</div>
			<UseCaseForm onsubmit={handleUseCaseSubmit} />
		</section>
	{/if}

	<!-- Step 2: Explore Designs -->
	{#if step === 2}
		<section>
			<div class="mb-6">
				<h1 class="mb-2 text-2xl font-bold text-gray-900">
					Top Designs for {formatLabel(useCase)}
				</h1>
				<p class="text-sm text-gray-500">
					Ranked by {formatLabel(useCase)} score. Click a design to see full specs, scores, and live listings.
				</p>
			</div>

			<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
				{#each rankedDesigns() as { boat, scores }, i}
					{@const key = useCaseToScore[useCase] ?? 'score_bluewater'}
					{@const score = scores[key] as number}
					<a
						href="/boats/{boat.id}"
						class="rounded-lg border border-gray-200 bg-white p-5 shadow-sm hover:border-blue-300 hover:shadow transition-all"
					>
						<div class="flex items-start justify-between">
							<div>
								<span class="text-xs font-bold text-gray-400">#{i + 1}</span>
								<div class="font-semibold text-gray-900">{boat.design_name}</div>
								<div class="text-xs text-gray-500">
									{boat.manufacturer} &middot; {boat.year_range_start}–{boat.year_range_end}
									{#if boat.length_ft}&middot; {boat.length_ft}ft{/if}
								</div>
							</div>
							<div class="text-right">
								<div class="text-2xl font-bold text-blue-600">{score}</div>
								<div class="text-xs text-gray-400">/ 100</div>
							</div>
						</div>

						<div class="mt-3 flex items-center gap-2">
							<div class="h-2 flex-1 overflow-hidden rounded-full bg-gray-200">
								<div class="h-full rounded-full bg-blue-500" style="width: {score}%"></div>
							</div>
						</div>

						{#if boat.rudder_type || boat.keel_type || boat.rig_type}
							<div class="mt-3 flex flex-wrap gap-1.5">
								{#if boat.rig_type}
									<span class="rounded bg-gray-100 px-2 py-0.5 text-xs text-gray-600">{formatLabel(boat.rig_type)}</span>
								{/if}
								{#if boat.keel_type}
									<span class="rounded bg-gray-100 px-2 py-0.5 text-xs text-gray-600">{formatLabel(boat.keel_type)}</span>
								{/if}
								{#if boat.rudder_type}
									<span class="rounded bg-gray-100 px-2 py-0.5 text-xs text-gray-600">{formatLabel(boat.rudder_type)}</span>
								{/if}
							</div>
						{/if}
					</a>
				{/each}
			</div>

			<div class="mt-6 text-center">
				<button
					onclick={() => (step = 3)}
					class="rounded-lg bg-blue-600 px-6 py-3 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
				>
					Find a Specific Boat
				</button>
			</div>
		</section>
	{/if}

	<!-- Step 3: Find a Boat -->
	{#if step === 3}
		<section class="space-y-8">
			<div>
				<h1 class="mb-2 text-2xl font-bold text-gray-900">Find a Specific Boat</h1>
				<p class="text-sm text-gray-500">
					Paste a listing URL or browse designs to find boats for sale.
				</p>
			</div>

			<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
				<h2 class="mb-4 text-lg font-semibold text-gray-900">Look Up a Listing</h2>
				<ListingLookup onsave={handleSaveListing} />
			</div>

			<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
				<Watchlist bind:this={watchlistRef} />
			</div>
		</section>
	{/if}
</div>
