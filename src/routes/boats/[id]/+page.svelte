<script lang="ts">
	import { page } from '$app/state';
	import { boats } from '$lib/seed-data';
	import { computeScores } from '$lib/scoring';
	import { buildPrompt } from '$lib/prompt-builder';
	import type { Boat, BoatScores } from '$lib/types';
	import BoatCard from '$lib/components/BoatCard.svelte';
	import ScoreRadar from '$lib/components/ScoreRadar.svelte';
	import ScoreBreakdown from '$lib/components/ScoreBreakdown.svelte';
	import PromptOutput from '$lib/components/PromptOutput.svelte';

	const boat = $derived(boats.find((b) => b.id === page.params.id));
	const scores = $derived(boat ? computeScores(boat) : null);

	let showPrompt = $state(false);
	let useCase = $state('bluewater passage-making');
	let experience = $state('intermediate');
	let targetWaters = $state('Pacific Ocean');

	const prompt = $derived(
		boat && scores
			? buildPrompt({
					boat,
					scores,
					use_case_primary: useCase,
					experience_level: experience,
					target_waters: targetWaters
				})
			: ''
	);
</script>

{#if boat && scores}
	<div class="space-y-8">
		<div>
			<a href="/boats" class="mb-4 inline-block text-sm text-blue-600 hover:text-blue-800">
				&larr; All Designs
			</a>
			<h1 class="text-2xl font-bold text-gray-900">{boat.design_name}</h1>
			<p class="text-gray-500">
				{boat.manufacturer} &middot; {boat.year_range_start ?? '?'}–{boat.year_range_end ?? '?'}
			</p>
		</div>

		<div class="grid gap-8 lg:grid-cols-2">
			<BoatCard {boat} />

			<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
				<h2 class="mb-4 text-lg font-semibold text-gray-900">Use-Case Scores</h2>
				<ScoreRadar {scores} />
			</div>
		</div>

		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-4 text-lg font-semibold text-gray-900">Score Breakdown</h2>
			<ScoreBreakdown {scores} />
		</div>

		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-4 text-lg font-semibold text-gray-900">Generate Claude Analysis</h2>
			<div class="mb-4 grid gap-4 sm:grid-cols-3">
				<div>
					<label for="use-case" class="mb-1 block text-sm font-medium text-gray-700">Primary Use Case</label>
					<select
						id="use-case"
						bind:value={useCase}
						class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
					>
						<option>bluewater passage-making</option>
						<option>coastal cruising</option>
						<option>Pacific circuit</option>
						<option>liveaboard cruiser</option>
						<option>weekend sailing</option>
					</select>
				</div>
				<div>
					<label for="experience" class="mb-1 block text-sm font-medium text-gray-700">Experience Level</label>
					<select
						id="experience"
						bind:value={experience}
						class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
					>
						<option>beginner</option>
						<option>intermediate</option>
						<option>experienced</option>
						<option>professional</option>
					</select>
				</div>
				<div>
					<label for="waters" class="mb-1 block text-sm font-medium text-gray-700">Target Waters</label>
					<select
						id="waters"
						bind:value={targetWaters}
						class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
					>
						<option>Pacific Ocean</option>
						<option>Atlantic Ocean</option>
						<option>Caribbean</option>
						<option>Mediterranean</option>
						<option>Pacific Northwest</option>
						<option>New England coast</option>
						<option>Around the world</option>
					</select>
				</div>
			</div>
			<button
				onclick={() => (showPrompt = !showPrompt)}
				class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
			>
				{showPrompt ? 'Hide Prompt' : 'Generate Prompt'}
			</button>
		</div>

		{#if showPrompt}
			<PromptOutput {prompt} />
		{/if}
	</div>
{:else}
	<div class="py-20 text-center">
		<h1 class="mb-2 text-2xl font-bold text-gray-900">Design Not Found</h1>
		<p class="mb-4 text-gray-500">The boat design you're looking for doesn't exist.</p>
		<a href="/boats" class="text-blue-600 hover:text-blue-800">Browse all designs</a>
	</div>
{/if}
