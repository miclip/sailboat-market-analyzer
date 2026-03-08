<script lang="ts">
	import type { Boat } from '$lib/types';
	import { formatLabel, formatNumber } from '$lib/utils';

	interface Props {
		boat: Boat;
	}

	let { boat }: Props = $props();
</script>

<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
	<h3 class="mb-1 text-lg font-semibold text-gray-900">{boat.design_name}</h3>
	<p class="mb-4 text-sm text-gray-500">
		{boat.manufacturer} &middot; {boat.year_range_start ?? '?'}–{boat.year_range_end ?? '?'}
	</p>

	<div class="grid grid-cols-2 gap-x-6 gap-y-2 text-sm md:grid-cols-3">
		{#if boat.length_ft}
			<div>
				<span class="text-gray-500">LOA</span>
				<span class="ml-1 font-medium">{boat.length_ft}ft</span>
			</div>
		{/if}
		{#if boat.beam_ft}
			<div>
				<span class="text-gray-500">Beam</span>
				<span class="ml-1 font-medium">{boat.beam_ft}ft</span>
			</div>
		{/if}
		{#if boat.displacement_lbs}
			<div>
				<span class="text-gray-500">Disp.</span>
				<span class="ml-1 font-medium">{formatNumber(boat.displacement_lbs)}lbs</span>
			</div>
		{/if}
		{#if boat.ballast_ratio}
			<div>
				<span class="text-gray-500">Ballast Ratio</span>
				<span class="ml-1 font-medium">{(boat.ballast_ratio * 100).toFixed(0)}%</span>
			</div>
		{/if}
		{#if boat.displacement_length_ratio}
			<div>
				<span class="text-gray-500">D/L Ratio</span>
				<span class="ml-1 font-medium">{boat.displacement_length_ratio}</span>
			</div>
		{/if}
		{#if boat.capsize_screening_value}
			<div>
				<span class="text-gray-500">CSV</span>
				<span class="ml-1 font-medium">{boat.capsize_screening_value.toFixed(2)}</span>
			</div>
		{/if}
		{#if boat.motion_comfort_ratio}
			<div>
				<span class="text-gray-500">MCR</span>
				<span class="ml-1 font-medium">{boat.motion_comfort_ratio.toFixed(1)}</span>
			</div>
		{/if}
		{#if boat.sa_displacement_ratio}
			<div>
				<span class="text-gray-500">SA/D</span>
				<span class="ml-1 font-medium">{boat.sa_displacement_ratio.toFixed(1)}</span>
			</div>
		{/if}
	</div>

	<div class="mt-4 grid grid-cols-2 gap-x-6 gap-y-2 border-t border-gray-100 pt-4 text-sm md:grid-cols-3">
		{#if boat.rudder_type}
			<div>
				<span class="text-gray-500">Rudder</span>
				<span class="ml-1 font-medium">{formatLabel(boat.rudder_type)}</span>
			</div>
		{/if}
		{#if boat.keel_type}
			<div>
				<span class="text-gray-500">Keel</span>
				<span class="ml-1 font-medium">{formatLabel(boat.keel_type)}</span>
			</div>
		{/if}
		{#if boat.rig_type}
			<div>
				<span class="text-gray-500">Rig</span>
				<span class="ml-1 font-medium">{formatLabel(boat.rig_type)}</span>
			</div>
		{/if}
		{#if boat.mast_step}
			<div>
				<span class="text-gray-500">Mast</span>
				<span class="ml-1 font-medium">{formatLabel(boat.mast_step)}</span>
			</div>
		{/if}
		{#if boat.cockpit_type}
			<div>
				<span class="text-gray-500">Cockpit</span>
				<span class="ml-1 font-medium">{formatLabel(boat.cockpit_type)}</span>
			</div>
		{/if}
		{#if boat.hull_type}
			<div>
				<span class="text-gray-500">Hull</span>
				<span class="ml-1 font-medium">{formatLabel(boat.hull_type)}</span>
			</div>
		{/if}
	</div>

	{#if boat.notes}
		<p class="mt-4 border-t border-gray-100 pt-4 text-sm text-gray-600">{boat.notes}</p>
	{/if}
</div>
