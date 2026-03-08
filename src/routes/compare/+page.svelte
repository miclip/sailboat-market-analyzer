<script lang="ts">
	import { boats } from '$lib/seed-data';
	import { computeScores } from '$lib/scoring';
	import type { Boat, BoatScores } from '$lib/types';
	import { formatLabel, formatNumber } from '$lib/utils';
	import ScoreRadar from '$lib/components/ScoreRadar.svelte';

	let selected: (Boat | null)[] = $state([null, null, null]);

	const scoredSelected = $derived(
		selected
			.filter((b): b is Boat => b !== null)
			.map((boat) => ({ boat, scores: computeScores(boat) }))
	);

	const scoreDimensions = [
		{ key: 'score_bluewater', label: 'Bluewater' },
		{ key: 'score_singlehand', label: 'Singlehand' },
		{ key: 'score_pacific_ready', label: 'Pacific Ready' },
		{ key: 'score_coastal_cruising', label: 'Coastal' },
		{ key: 'score_liveaboard', label: 'Liveaboard' },
		{ key: 'score_upwind', label: 'Upwind' },
		{ key: 'score_downwind', label: 'Downwind' }
	] as const;

	const specRows = [
		{ label: 'LOA', fn: (b: Boat) => b.length_ft ? `${b.length_ft}ft` : '—' },
		{ label: 'Beam', fn: (b: Boat) => b.beam_ft ? `${b.beam_ft}ft` : '—' },
		{ label: 'Displacement', fn: (b: Boat) => b.displacement_lbs ? `${formatNumber(b.displacement_lbs)}lbs` : '—' },
		{ label: 'Ballast Ratio', fn: (b: Boat) => b.ballast_ratio ? `${(b.ballast_ratio * 100).toFixed(0)}%` : '—' },
		{ label: 'D/L Ratio', fn: (b: Boat) => b.displacement_length_ratio?.toFixed(0) ?? '—' },
		{ label: 'CSV', fn: (b: Boat) => b.capsize_screening_value?.toFixed(2) ?? '—' },
		{ label: 'MCR', fn: (b: Boat) => b.motion_comfort_ratio?.toFixed(1) ?? '—' },
		{ label: 'SA/D', fn: (b: Boat) => b.sa_displacement_ratio?.toFixed(1) ?? '—' },
		{ label: 'Rudder', fn: (b: Boat) => b.rudder_type ? formatLabel(b.rudder_type) : '—' },
		{ label: 'Keel', fn: (b: Boat) => b.keel_type ? formatLabel(b.keel_type) : '—' },
		{ label: 'Rig', fn: (b: Boat) => b.rig_type ? formatLabel(b.rig_type) : '—' },
		{ label: 'Mast', fn: (b: Boat) => b.mast_step ? formatLabel(b.mast_step) : '—' },
		{ label: 'Cockpit', fn: (b: Boat) => b.cockpit_type ? formatLabel(b.cockpit_type) : '—' }
	];
</script>

<div class="space-y-8">
	<h1 class="text-2xl font-bold text-gray-900">Compare Designs</h1>

	<div class="grid gap-4 sm:grid-cols-3">
		{#each [0, 1, 2] as i}
			<select
				value={selected[i]?.id ?? ''}
				onchange={(e) => {
					const target = e.target as HTMLSelectElement;
					selected[i] = boats.find((b) => b.id === target.value) ?? null;
				}}
				class="rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
			>
				<option value="">Select boat {i + 1}...</option>
				{#each boats as boat}
					<option value={boat.id}>{boat.design_name}</option>
				{/each}
			</select>
		{/each}
	</div>

	{#if scoredSelected.length >= 2}
		<!-- Score comparison bars -->
		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-4 text-lg font-semibold text-gray-900">Score Comparison</h2>
			<div class="space-y-4">
				{#each scoreDimensions as dim}
					<div>
						<div class="mb-1 text-sm font-medium text-gray-700">{dim.label}</div>
						{#each scoredSelected as { boat, scores }, j}
							{@const score = scores[dim.key] as number}
							{@const colors = ['bg-blue-500', 'bg-green-500', 'bg-purple-500']}
							<div class="mb-1 flex items-center gap-2">
								<span class="w-28 truncate text-xs text-gray-500">{boat.design_name}</span>
								<div class="h-3 flex-1 overflow-hidden rounded-full bg-gray-100">
									<div class="h-full rounded-full {colors[j]}" style="width: {score}%"></div>
								</div>
								<span class="w-6 text-right text-xs font-medium">{score}</span>
							</div>
						{/each}
					</div>
				{/each}
			</div>
		</div>

		<!-- Spec diff table -->
		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-4 text-lg font-semibold text-gray-900">Specifications</h2>
			<div class="overflow-x-auto">
				<table class="w-full text-sm">
					<thead>
						<tr class="border-b border-gray-200">
							<th class="py-2 pr-4 text-left font-medium text-gray-500">Spec</th>
							{#each scoredSelected as { boat }}
								<th class="py-2 px-4 text-left font-medium text-gray-900">{boat.design_name}</th>
							{/each}
						</tr>
					</thead>
					<tbody>
						{#each specRows as row}
							<tr class="border-b border-gray-100">
								<td class="py-2 pr-4 text-gray-500">{row.label}</td>
								{#each scoredSelected as { boat }}
									<td class="py-2 px-4 text-gray-900">{row.fn(boat)}</td>
								{/each}
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		</div>
	{:else}
		<div class="rounded-lg border border-gray-200 bg-white p-12 text-center shadow-sm">
			<p class="text-gray-500">Select at least 2 designs to compare.</p>
		</div>
	{/if}
</div>
