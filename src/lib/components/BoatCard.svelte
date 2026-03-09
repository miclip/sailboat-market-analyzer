<script lang="ts">
	import type { Boat } from '$lib/types';
	import { formatLabel, formatNumber } from '$lib/utils';
	import InfoTip from './InfoTip.svelte';

	interface Props {
		boat: Boat;
	}

	let { boat }: Props = $props();

	const specTips: Record<string, string> = {
		LOA: 'Length Overall — the total length of the boat from bow to stern.',
		Beam: 'The widest point of the hull. Wider boats have more interior space but may be slower upwind.',
		'Disp.': 'Total weight of the boat fully loaded. Heavier boats are more stable but slower.',
		'Ballast Ratio': 'Percentage of total weight that is ballast (lead or iron in the keel). Higher means better self-righting ability.',
		'D/L Ratio': 'Displacement-to-Length ratio. Over 300 is heavy, under 200 is light. Heavy boats are more comfortable in waves.',
		CSV: 'Capsize Screening Value. Below 2.0 is considered safe for offshore. Lower is better.',
		MCR: 'Motion Comfort Ratio. Higher means a smoother ride. 30+ is good for bluewater, 20+ for coastal.',
		'SA/D': 'Sail Area to Displacement ratio. Higher means more sail power relative to weight. 16+ is well-powered.',
		Rudder: 'Skeg-hung rudders are protected and strong. Spade rudders are responsive but exposed. Full keel integrated is the most protected.',
		Keel: 'Full keels track well but are heavy. Modified fin is the modern bluewater standard. Fin keels are fast but less stable.',
		Rig: 'Sloop is simplest. Cutter adds an inner forestay for heavy weather. Ketch has two masts for flexible sail plans. Cutter ketch combines both.',
		Mast: 'Keel-stepped goes through the deck to the hull — stronger. Deck-stepped sits on the deck — lighter, easier to service.',
		Cockpit: 'Center cockpits have a protected helm and larger aft cabin. Aft cockpits offer better sail handling access.',
		Hull: 'The shape of the underwater hull. Full keel is traditional and protective. Fin keel is modern and fast.',
		Cabins: 'Number of separate sleeping cabins.',
		Berths: 'Total number of sleeping positions (including settees and convertible areas).',
		'Sea Berths': 'Berths usable while sailing — positioned low and along the centerline for comfort in a seaway.'
	};
</script>

<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
	<h3 class="mb-1 text-lg font-semibold text-gray-900">{boat.design_name}</h3>
	<p class="mb-4 text-sm text-gray-500">
		{boat.manufacturer} &middot; {boat.year_range_start ?? '?'}–{boat.year_range_end ?? '?'}
	</p>

	<div class="grid grid-cols-2 gap-x-6 gap-y-2 text-sm md:grid-cols-3">
		{#if boat.length_ft}
			<div>
				<span class="text-gray-500">LOA<InfoTip text={specTips.LOA} /></span>
				<span class="ml-1 font-medium">{boat.length_ft}ft</span>
			</div>
		{/if}
		{#if boat.beam_ft}
			<div>
				<span class="text-gray-500">Beam<InfoTip text={specTips.Beam} /></span>
				<span class="ml-1 font-medium">{boat.beam_ft}ft</span>
			</div>
		{/if}
		{#if boat.displacement_lbs}
			<div>
				<span class="text-gray-500">Disp.<InfoTip text={specTips['Disp.']} /></span>
				<span class="ml-1 font-medium">{formatNumber(boat.displacement_lbs)}lbs</span>
			</div>
		{/if}
		{#if boat.ballast_ratio}
			<div>
				<span class="text-gray-500">Ballast Ratio<InfoTip text={specTips['Ballast Ratio']} /></span>
				<span class="ml-1 font-medium">{(boat.ballast_ratio * 100).toFixed(0)}%</span>
			</div>
		{/if}
		{#if boat.displacement_length_ratio}
			<div>
				<span class="text-gray-500">D/L Ratio<InfoTip text={specTips['D/L Ratio']} /></span>
				<span class="ml-1 font-medium">{boat.displacement_length_ratio}</span>
			</div>
		{/if}
		{#if boat.capsize_screening_value}
			<div>
				<span class="text-gray-500">CSV<InfoTip text={specTips.CSV} /></span>
				<span class="ml-1 font-medium">{boat.capsize_screening_value.toFixed(2)}</span>
			</div>
		{/if}
		{#if boat.motion_comfort_ratio}
			<div>
				<span class="text-gray-500">MCR<InfoTip text={specTips.MCR} /></span>
				<span class="ml-1 font-medium">{boat.motion_comfort_ratio.toFixed(1)}</span>
			</div>
		{/if}
		{#if boat.sa_displacement_ratio}
			<div>
				<span class="text-gray-500">SA/D<InfoTip text={specTips['SA/D']} /></span>
				<span class="ml-1 font-medium">{boat.sa_displacement_ratio.toFixed(1)}</span>
			</div>
		{/if}
		{#if boat.cabins}
			<div>
				<span class="text-gray-500">Cabins<InfoTip text={specTips.Cabins} /></span>
				<span class="ml-1 font-medium">{boat.cabins}</span>
			</div>
		{/if}
		{#if boat.berths}
			<div>
				<span class="text-gray-500">Berths<InfoTip text={specTips.Berths} /></span>
				<span class="ml-1 font-medium">{boat.berths}</span>
			</div>
		{/if}
		{#if boat.sea_berths}
			<div>
				<span class="text-gray-500">Sea Berths<InfoTip text={specTips['Sea Berths']} /></span>
				<span class="ml-1 font-medium">{boat.sea_berths}</span>
			</div>
		{/if}
	</div>

	<div class="mt-4 grid grid-cols-2 gap-x-6 gap-y-2 border-t border-gray-100 pt-4 text-sm md:grid-cols-3">
		{#if boat.rudder_type}
			<div>
				<span class="text-gray-500">Rudder<InfoTip text={specTips.Rudder} /></span>
				<span class="ml-1 font-medium">{formatLabel(boat.rudder_type)}</span>
			</div>
		{/if}
		{#if boat.keel_type}
			<div>
				<span class="text-gray-500">Keel<InfoTip text={specTips.Keel} /></span>
				<span class="ml-1 font-medium">{formatLabel(boat.keel_type)}</span>
			</div>
		{/if}
		{#if boat.rig_type}
			<div>
				<span class="text-gray-500">Rig<InfoTip text={specTips.Rig} /></span>
				<span class="ml-1 font-medium">{formatLabel(boat.rig_type)}</span>
			</div>
		{/if}
		{#if boat.mast_step}
			<div>
				<span class="text-gray-500">Mast<InfoTip text={specTips.Mast} /></span>
				<span class="ml-1 font-medium">{formatLabel(boat.mast_step)}</span>
			</div>
		{/if}
		{#if boat.cockpit_type}
			<div>
				<span class="text-gray-500">Cockpit<InfoTip text={specTips.Cockpit} /></span>
				<span class="ml-1 font-medium">{formatLabel(boat.cockpit_type)}</span>
			</div>
		{/if}
		{#if boat.hull_type}
			<div>
				<span class="text-gray-500">Hull<InfoTip text={specTips.Hull} /></span>
				<span class="ml-1 font-medium">{formatLabel(boat.hull_type)}</span>
			</div>
		{/if}
	</div>

	{#if boat.notes}
		<p class="mt-4 border-t border-gray-100 pt-4 text-sm text-gray-600">{boat.notes}</p>
	{/if}
</div>
