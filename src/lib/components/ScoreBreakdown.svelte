<script lang="ts">
	import type { BoatScores, ScoreDimension } from '$lib/types';
	import { formatLabel } from '$lib/utils';
	import InfoTip from './InfoTip.svelte';

	interface Props {
		scores: BoatScores;
		initialDimension?: ScoreDimension;
	}

	let { scores, initialDimension }: Props = $props();

	let selectedDimension = $state<ScoreDimension>('bluewater');
	$effect(() => {
		if (initialDimension) selectedDimension = initialDimension;
	});

	const dimensionDescriptions: Record<ScoreDimension, string> = {
		coastal_cruising: 'Suitability for day sailing and short coastal passages. Favors ease of handling, moderate size, and good performance.',
		bluewater: 'Offshore passage-making capability. Prioritizes structural strength, stability, safety features, and sea-kindliness.',
		pacific_ready: 'Readiness for Pacific circuit cruising. Combines bluewater capability, singlehand friendliness, and liveaboard comfort.',
		singlehand: 'How well the boat can be sailed alone. Considers rig simplicity, cockpit layout, self-steering, and manageable size.',
		liveaboard: 'Comfort as a full-time home at the dock. Values space, beam, open layout, and cockpit type.',
		upwind: 'Ability to sail efficiently to windward. Rewards fin keels, high SA/D ratio, and narrow beam.',
		downwind: 'Stability and comfort running before the wind. Considers motion comfort, keel tracking, and displacement.'
	};

	const factorDescriptions: Record<string, string> = {
		'Rudder Type': 'Skeg-hung rudders are protected from debris and structurally supported. Spade rudders are more responsive but vulnerable offshore.',
		'Keel Type': 'Modified fin offers the best blend of tracking and maneuverability. Full keels are protective but add drag and can roll downwind.',
		'Mast Step': 'Keel-stepped masts transfer loads to the hull and leave a stump if broken. Deck-stepped is lighter and easier to service.',
		'Backstay': 'A permanent backstay provides forestay tension control and mast redundancy. Some rigs (B&R, swept spreader) omit it.',
		'Galley Safety': 'U-shaped and L-shaped galleys let you brace while cooking at sea. Open linear layouts offer no bracing in rough conditions.',
		'Galley Layout': 'For dockside living, open layouts feel spacious and modern. U-shaped galleys offer more counter space and storage.',
		'Capsize Screening': 'Lower values indicate better resistance to capsize. Below 2.0 is considered safe for offshore sailing.',
		'D/L Ratio': 'Displacement-to-length ratio. Higher means heavier for its size — more comfortable in waves but slower.',
		'Motion Comfort': 'Predicts how comfortable the ride will be in a seaway. Higher is smoother. 30+ is good for bluewater, 20+ for coastal.',
		'SA/D Ratio': 'Sail area to displacement ratio. Higher means more power relative to weight — better light-air performance but harder to manage.',
		'Cockpit Type': 'Center cockpits provide a protected helm position and larger aft cabins. Aft cockpits offer better sail handling access.',
		'Rig Type': 'Ketches and cutters offer flexible sail plans for varying conditions. Sloops are simpler to manage.',
		'Self-Steering': 'Whether the boat can accommodate a wind vane or autopilot for hands-free sailing on long passages.',
		'LOA': 'Overall length affects livable space, speed potential, and handling difficulty.',
		'Beam': 'Wider boats offer more interior volume but can be less weatherly upwind.',
		'Ease of Handling': 'Combines size, rig complexity, displacement, and mast type to estimate how manageable the boat is.',
		'Size': 'For coastal cruising, 34-42ft is the sweet spot — big enough to be comfortable, small enough to handle easily.',
		'Stability': 'Resistance to capsize based on beam, displacement, and hull form. Critical for offshore safety.',
		'Displacement': 'Heavier boats are more stable in following seas but slower to accelerate.',
		'Forefoot Depth': 'Deep forefoots track better downwind, reducing the tendency to broach in following seas.',
		'Ballast Ratio': 'Percentage of total weight that is ballast. Higher ratios mean stronger self-righting ability — critical for bluewater safety.'
	};

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

	{#if dimensionDescriptions[selectedDimension]}
		<p class="mb-4 text-xs text-gray-500">{dimensionDescriptions[selectedDimension]}</p>
	{/if}

	{#if breakdownItems.length > 0}
		<div class="space-y-3">
			{#each breakdownItems as item}
				<div>
					<div class="mb-1 flex items-center justify-between text-sm">
						<span class="font-medium text-gray-700">
							{item.factor}
							{#if factorDescriptions[item.factor]}
								<InfoTip text={factorDescriptions[item.factor]} />
							{/if}
						</span>
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
