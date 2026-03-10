<script lang="ts">
	import { page } from '$app/state';
	import { goto } from '$app/navigation';
	import { boats } from '$lib/seed-data';
	import { computeScores } from '$lib/scoring';
	import { supabase } from '$lib/supabase';
	import type { Boat, BoatScores, MarketSnapshot } from '$lib/types';
	import { formatLabel, formatNumber, formatCurrency } from '$lib/utils';
	import CompareRadar from '$lib/components/CompareRadar.svelte';

	const COLORS = [
		{ hex: '#3b82f6', fill: 'rgba(59,130,246,0.15)', bg: 'bg-blue-500', text: 'text-blue-600', pill: 'bg-blue-50 text-blue-700' },
		{ hex: '#10b981', fill: 'rgba(16,185,129,0.15)', bg: 'bg-green-500', text: 'text-green-600', pill: 'bg-green-50 text-green-700' },
		{ hex: '#8b5cf6', fill: 'rgba(139,92,246,0.15)', bg: 'bg-purple-500', text: 'text-purple-600', pill: 'bg-purple-50 text-purple-700' }
	];

	// Initialize from URL params (?b=id1&b=id2&b=id3)
	const initialIds = page.url.searchParams.getAll('b');
	let selected: (Boat | null)[] = $state([
		boats.find((b) => b.id === initialIds[0]) ?? null,
		boats.find((b) => b.id === initialIds[1]) ?? null,
		boats.find((b) => b.id === initialIds[2]) ?? null
	]);

	// Sync URL when selection changes
	$effect(() => {
		const ids = selected.filter((b): b is Boat => b !== null).map((b) => b.id);
		const params = new URLSearchParams();
		for (const id of ids) params.append('b', id);
		const newUrl = ids.length > 0 ? `/compare?${params.toString()}` : '/compare';
		if (newUrl !== `${page.url.pathname}${page.url.search}`) {
			goto(newUrl, { replaceState: true, keepFocus: true, noScroll: true });
		}
	});

	const scoredSelected = $derived(
		selected
			.filter((b): b is Boat => b !== null)
			.map((boat, i) => ({ boat, scores: computeScores(boat), colorIdx: selected.indexOf(boat) }))
	);

	const scoreDimensions = [
		{ key: 'score_bluewater', label: 'Bluewater' },
		{ key: 'score_pacific_ready', label: 'Pacific Ready' },
		{ key: 'score_singlehand', label: 'Singlehand' },
		{ key: 'score_coastal_cruising', label: 'Coastal' },
		{ key: 'score_liveaboard', label: 'Liveaboard' },
		{ key: 'score_upwind', label: 'Upwind' },
		{ key: 'score_downwind', label: 'Downwind' }
	] as const;

	// Dimension winners
	const dimensionResults = $derived(
		scoreDimensions.map((dim) => {
			const entries = scoredSelected.map((s) => ({
				name: s.boat.design_name,
				score: s.scores[dim.key] as number,
				colorIdx: s.colorIdx
			}));
			const sorted = [...entries].sort((a, b) => b.score - a.score);
			const isTie = sorted.length > 1 && sorted[0].score === sorted[1].score;
			return { dim, entries, winner: isTie ? null : sorted[0], isTie };
		})
	);

	// Spec rows with best-value logic
	const specRows: Array<{
		label: string;
		fn: (b: Boat) => string;
		raw: (b: Boat) => number | null;
		best: 'high' | 'low' | null;
	}> = [
		{ label: 'LOA', fn: (b) => b.length_ft ? `${b.length_ft}ft` : '—', raw: (b) => b.length_ft ?? null, best: null },
		{ label: 'Beam', fn: (b) => b.beam_ft ? `${b.beam_ft}ft` : '—', raw: (b) => b.beam_ft ?? null, best: null },
		{ label: 'Displacement', fn: (b) => b.displacement_lbs ? `${formatNumber(b.displacement_lbs)}lbs` : '—', raw: (b) => b.displacement_lbs ?? null, best: null },
		{ label: 'Ballast Ratio', fn: (b) => b.ballast_ratio ? `${(b.ballast_ratio * 100).toFixed(0)}%` : '—', raw: (b) => b.ballast_ratio ?? null, best: 'high' },
		{ label: 'D/L Ratio', fn: (b) => b.displacement_length_ratio?.toFixed(0) ?? '—', raw: (b) => b.displacement_length_ratio ?? null, best: null },
		{ label: 'CSV', fn: (b) => b.capsize_screening_value?.toFixed(2) ?? '—', raw: (b) => b.capsize_screening_value ?? null, best: 'low' },
		{ label: 'MCR', fn: (b) => b.motion_comfort_ratio?.toFixed(1) ?? '—', raw: (b) => b.motion_comfort_ratio ?? null, best: 'high' },
		{ label: 'SA/D', fn: (b) => b.sa_displacement_ratio?.toFixed(1) ?? '—', raw: (b) => b.sa_displacement_ratio ?? null, best: 'high' },
		{ label: 'Rudder', fn: (b) => b.rudder_type ? formatLabel(b.rudder_type) : '—', raw: () => null, best: null },
		{ label: 'Keel', fn: (b) => b.keel_type ? formatLabel(b.keel_type) : '—', raw: () => null, best: null },
		{ label: 'Rig', fn: (b) => b.rig_type ? formatLabel(b.rig_type) : '—', raw: () => null, best: null },
		{ label: 'Mast', fn: (b) => b.mast_step ? formatLabel(b.mast_step) : '—', raw: () => null, best: null },
		{ label: 'Cockpit', fn: (b) => b.cockpit_type ? formatLabel(b.cockpit_type) : '—', raw: () => null, best: null },
		{ label: 'Cabins', fn: (b) => b.cabins?.toString() ?? '—', raw: (b) => b.cabins ?? null, best: null },
		{ label: 'Berths', fn: (b) => b.berths?.toString() ?? '—', raw: (b) => b.berths ?? null, best: null }
	];

	function bestIndex(row: typeof specRows[number], boats: Boat[]): number | null {
		if (!row.best) return null;
		const values = boats.map((b) => row.raw(b));
		const valid = values.filter((v): v is number => v != null);
		if (valid.length < 2) return null;
		const target = row.best === 'high' ? Math.max(...valid) : Math.min(...valid);
		const idx = values.indexOf(target);
		// Only highlight if it's clearly better (not a tie)
		const others = valid.filter((v) => v !== target);
		if (others.length === 0) return null;
		const diff = Math.abs(target - others[0]);
		if (diff < 0.01) return null;
		return idx;
	}

	// Market snapshot data
	let marketData = $state<Map<string, MarketSnapshot>>(new Map());

	$effect(() => {
		const ids = scoredSelected.map((s) => s.boat.id);
		if (ids.length === 0) {
			marketData = new Map();
			return;
		}
		supabase
			.from('market_snapshots')
			.select('*')
			.in('boat_design_id', ids)
			.order('snapshot_date', { ascending: false })
			.then(({ data }) => {
				const map = new Map<string, MarketSnapshot>();
				for (const row of (data ?? []) as MarketSnapshot[]) {
					if (!map.has(row.boat_design_id)) {
						map.set(row.boat_design_id, row);
					}
				}
				marketData = map;
			});
	});

	// Radar entries
	const radarEntries = $derived(
		scoredSelected.map((s) => ({
			name: s.boat.design_name,
			scores: s.scores,
			color: COLORS[s.colorIdx].hex,
			fill: COLORS[s.colorIdx].fill
		}))
	);
</script>

<div class="space-y-8">
	<h1 class="text-2xl font-bold text-gray-900">Compare Designs</h1>

	<!-- Boat selectors with info -->
	<div class="grid gap-4 sm:grid-cols-3">
		{#each [0, 1, 2] as i}
			<div>
				<select
					value={selected[i]?.id ?? ''}
					onchange={(e) => {
						const target = e.target as HTMLSelectElement;
						selected[i] = boats.find((b) => b.id === target.value) ?? null;
					}}
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				>
					<option value="">Select boat {i + 1}...</option>
					{#each boats as boat}
						<option value={boat.id}>{boat.design_name}</option>
					{/each}
				</select>
				{#if selected[i]}
					<div class="mt-2 flex items-center gap-2">
						<span class="inline-block h-2.5 w-2.5 rounded-full {COLORS[i].bg}"></span>
						<a href="/boats/{selected[i]!.id}" class="text-sm font-medium {COLORS[i].text} hover:underline">
							{selected[i]!.design_name}
						</a>
					</div>
					<div class="ml-[18px] text-xs text-gray-500">
						{selected[i]!.manufacturer} &middot; {selected[i]!.year_range_start ?? '?'}–{selected[i]!.year_range_end ?? '?'}
						{#if selected[i]!.length_ft}
							&middot; {selected[i]!.length_ft}ft
						{/if}
					</div>
				{/if}
			</div>
		{/each}
	</div>

	{#if scoredSelected.length >= 2}
		<!-- Overlaid radar chart -->
		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-4 text-lg font-semibold text-gray-900">Score Overlay</h2>
			<CompareRadar entries={radarEntries} />
		</div>

		<!-- Head to Head with bars -->
		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-4 text-lg font-semibold text-gray-900">Head to Head</h2>
			<div class="space-y-5">
				{#each dimensionResults as { dim, entries, winner, isTie }}
					<div>
						<div class="mb-1.5 flex items-center justify-between">
							<span class="text-sm font-medium text-gray-700">{dim.label}</span>
							<div>
								{#if isTie}
									<span class="rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-medium text-gray-500">Tie</span>
								{:else if winner}
									<span class="rounded-full px-2.5 py-0.5 text-xs font-medium {COLORS[winner.colorIdx].pill}">
										{winner.name.length > 20 ? winner.name.substring(0, 18) + '...' : winner.name}
									</span>
								{/if}
							</div>
						</div>
						{#each entries as entry}
							{@const isWinner = winner && entry.name === winner.name}
							<div class="mb-1 flex items-center gap-2">
								<div class="h-4 flex-1 overflow-hidden rounded-full bg-gray-100">
									<div
										class="h-full rounded-full transition-all"
										style="width: {entry.score}%; background-color: {COLORS[entry.colorIdx].hex}; opacity: {isWinner || isTie ? 1 : 0.45}"
									></div>
								</div>
								<span class="w-7 text-right text-xs font-medium {isWinner ? 'text-gray-900' : 'text-gray-400'}">{entry.score}</span>
							</div>
						{/each}
					</div>
				{/each}
			</div>
		</div>

		<!-- Market Data -->
		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-4 text-lg font-semibold text-gray-900">Market Data</h2>
			<div class="grid gap-4 sm:grid-cols-{scoredSelected.length}">
				{#each scoredSelected as { boat, colorIdx }}
					{@const snap = marketData.get(boat.id)}
					<div class="rounded-lg border border-gray-100 bg-gray-50 p-4">
						<div class="mb-2 flex items-center gap-2">
							<span class="inline-block h-2.5 w-2.5 rounded-full {COLORS[colorIdx].bg}"></span>
							<span class="text-sm font-medium text-gray-900">{boat.design_name}</span>
						</div>
						{#if snap}
							<div class="space-y-1.5">
								<div>
									<span class="text-xs text-gray-500">Median Price</span>
									<div class="text-lg font-bold text-blue-600">
										{snap.median_price != null ? formatCurrency(snap.median_price) : '—'}
									</div>
								</div>
								<div class="flex gap-4 text-xs text-gray-500">
									<span>{snap.listing_count} listing{snap.listing_count !== 1 ? 's' : ''}</span>
									{#if snap.min_price != null && snap.max_price != null}
										<span>{formatCurrency(snap.min_price)}–{formatCurrency(snap.max_price)}</span>
									{/if}
								</div>
								{#if boat.length_ft && snap.median_price}
									<div class="text-xs text-gray-400">
										{formatCurrency(Math.round(snap.median_price / boat.length_ft))}/ft
									</div>
								{/if}
							</div>
						{:else}
							<p class="text-sm text-gray-400">No market data yet</p>
						{/if}
					</div>
				{/each}
			</div>
		</div>

		<!-- Spec comparison table -->
		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-4 text-lg font-semibold text-gray-900">Specifications</h2>
			<div class="overflow-x-auto">
				<table class="w-full text-sm">
					<thead>
						<tr class="border-b border-gray-200">
							<th class="py-2 pr-4 text-left font-medium text-gray-500">Spec</th>
							{#each scoredSelected as { boat, colorIdx }}
								<th class="py-2 px-4 text-left">
									<a href="/boats/{boat.id}" class="font-medium {COLORS[colorIdx].text} hover:underline">
										{boat.design_name}
									</a>
								</th>
							{/each}
						</tr>
					</thead>
					<tbody>
						{#each specRows as row}
							{@const best = bestIndex(row, scoredSelected.map((s) => s.boat))}
							<tr class="border-b border-gray-100">
								<td class="py-2 pr-4 text-gray-500">{row.label}</td>
								{#each scoredSelected as { boat }, j}
									<td class="py-2 px-4 {best === j ? 'font-bold text-green-700 bg-green-50' : 'text-gray-900'}">
										{row.fn(boat)}
									</td>
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
