<script lang="ts">
	import { page } from '$app/state';
	import { boats } from '$lib/seed-data';
	import { computeScores } from '$lib/scoring';
	import { supabase } from '$lib/supabase';
	import type { Boat, BoatScores, WatchlistItem, UserPreferences } from '$lib/types';
	import { defaultPreferences } from '$lib/types';
	import UseCaseForm from '$lib/components/UseCaseForm.svelte';
	import PreferencesForm from '$lib/components/PreferencesForm.svelte';
	import { getUser } from '$lib/auth.svelte';
	import { formatLabel, formatCurrency } from '$lib/utils';

	interface ScoredBoat {
		boat: Boat;
		scores: BoatScores;
	}

	const scoredBoats: ScoredBoat[] = boats.map((b) => ({ boat: b, scores: computeScores(b) }));

	// Restore state from URL params (e.g. when navigating back from boat detail)
	const qsStep = Number(page.url.searchParams.get('step')) || 0;
	const qsUc = page.url.searchParams.get('uc') ?? '';
	const qsExp = page.url.searchParams.get('exp') ?? '';
	const qsWaters = page.url.searchParams.get('waters') ?? '';

	let step = $state(qsStep >= 1 && qsStep <= 4 ? qsStep : 1);
	let useCase = $state(qsUc || '');
	let experience = $state(qsExp || '');
	let waters = $state(qsWaters || '');
	let preferences = $state<UserPreferences>({ ...defaultPreferences });

	const user = $derived(getUser());

	function scoreTextColor(score: number): string {
		if (score >= 80) return 'text-blue-600';
		if (score >= 60) return 'text-purple-600';
		if (score >= 40) return 'text-orange-500';
		return 'text-red-500';
	}

	function scoreBarColor(score: number): string {
		if (score >= 80) return 'bg-blue-500';
		if (score >= 60) return 'bg-purple-500';
		if (score >= 40) return 'bg-orange-400';
		return 'bg-red-500';
	}

	// Watchlist state for step 3
	let watchlistItems = $state<WatchlistItem[]>([]);
	let watchlistLoading = $state(false);
	let watchlistLoaded = $state(false);
	let showPrompt = $state(false);

	// Load watchlist when user is available and we reach step 3
	$effect(() => {
		if (user && step === 4 && !watchlistLoaded) {
			watchlistLoaded = true;
			loadWatchlist();
		}
	});

	async function loadWatchlist() {
		if (!user) return;
		watchlistLoading = true;
		const { data } = await supabase
			.from('watchlist')
			.select('*')
			.eq('user_id', user.id)
			.order('created_at', { ascending: false });
		watchlistItems = data ?? [];
		watchlistLoading = false;
	}

	async function removeItem(id: string) {
		await supabase.from('watchlist').delete().eq('id', id);
		watchlistItems = watchlistItems.filter((i) => i.id !== id);
	}

	// Primary score key per use case
	const useCaseToScore: Record<string, keyof BoatScores> = {
		bluewater: 'score_bluewater',
		pacific: 'score_pacific_ready',
		coastal: 'score_coastal_cruising',
		liveaboard: 'score_liveaboard',
		singlehand: 'score_singlehand',
		circumnavigation: 'score_pacific_ready'
	};

	const useCaseLabels: Record<string, string> = {
		bluewater: 'bluewater passage-making',
		pacific: 'Pacific circuit',
		coastal: 'coastal cruising',
		liveaboard: 'liveaboard cruiser',
		singlehand: 'singlehanded sailing',
		circumnavigation: 'circumnavigation'
	};

	function compositeScore(boat: Boat, scores: BoatScores): number {
		const key = useCaseToScore[useCase] ?? 'score_bluewater';
		let base = scores[key] as number;

		const loa = boat.length_ft ?? 40;
		const disp = boat.displacement_lbs ?? 20000;
		const rig = boat.rig_type ?? 'sloop';

		if (experience === 'beginner') {
			if (loa > 45) base -= (loa - 45) * 3;
			else if (loa > 42) base -= (loa - 42) * 1.5;
			if (loa <= 40) base += 5;
			if (disp > 25000) base -= 10;
			else if (disp < 18000) base += 5;
			if (rig === 'ketch' || rig === 'cutter_ketch' || rig === 'schooner') base -= 10;
			if (rig === 'sloop') base += 5;
		} else if (experience === 'intermediate') {
			if (loa > 50) base -= (loa - 50) * 2;
			if (loa <= 42) base += 3;
		} else if (experience === 'professional') {
			base += (scores.score_bluewater as number) * 0.1;
		}

		const protectedWaters = ['Caribbean', 'Mediterranean', 'Gulf Coast', 'Great Lakes'];
		const openOcean = ['Pacific Ocean', 'Atlantic Ocean', 'Around the World'];

		if (protectedWaters.includes(waters)) {
			if (scores.score_bluewater > 85 && useCase === 'coastal') base -= 10;
			base += (scores.score_coastal_cruising as number) * 0.15;
		}

		if (openOcean.includes(waters)) {
			base += (scores.score_bluewater as number) * 0.1;
			if (scores.score_bluewater < 50) base -= 10;
		}

		return Math.round(Math.max(0, Math.min(100, base)));
	}

	function passesHardFilters(boat: Boat): boolean {
		const p = preferences;
		if (p.cockpit_type && boat.cockpit_type !== p.cockpit_type) return false;
		if (p.no_teak_decks && boat.has_teak_decks) return false;
		if (p.no_canoe_stern && boat.stern_type === 'canoe') return false;
		if (p.min_loa_ft && boat.length_ft && boat.length_ft < p.min_loa_ft) return false;
		if (p.max_loa_ft && boat.length_ft && boat.length_ft > p.max_loa_ft) return false;
		return true;
	}

	function preferenceBoost(boat: Boat): number {
		const p = preferences;
		let boost = 0;
		if (p.rig_preference && boat.rig_type === p.rig_preference) boost += 8;
		if (p.galley_preference && boat.galley_layout === p.galley_preference) boost += 5;
		if (p.prefer_keel_stepped && boat.mast_step === 'keel_stepped') boost += 5;
		return boost;
	}

	const rankedDesigns = $derived(() => {
		const _uc = useCase;
		const _exp = experience;
		const _wat = waters;
		const _prefs = preferences;
		return scoredBoats
			.filter((sb) => passesHardFilters(sb.boat))
			.map((sb) => ({
				...sb,
				composite: Math.min(100, compositeScore(sb.boat, sb.scores) + preferenceBoost(sb.boat))
			}))
			.toSorted((a, b) => b.composite - a.composite);
	});

	function handleUseCaseSubmit(uc: string, exp: string, w: string) {
		useCase = uc;
		experience = exp;
		waters = w;
		step = 2;
	}

	function handlePrefsChange(prefs: UserPreferences) {
		preferences = prefs;
	}

	function buildAnalysisPrompt(): string {
		const lines: string[] = [
			`You are helping a sailor evaluate boats for purchase.`,
			'',
			'## Buyer Profile',
			`Use Case: ${useCaseLabels[useCase] ?? useCase}`,
			`Experience: ${formatLabel(experience)}`,
			`Target Waters: ${waters}`,
			''
		];

		if (watchlistItems.length > 0) {
			lines.push('## Boats Under Consideration', '');
			for (const item of watchlistItems) {
				const design = boats.find(
					(b) => b.manufacturer.toLowerCase() === item.make.toLowerCase()
						&& b.design_name.toLowerCase().includes(item.model.toLowerCase())
				);
				const scores = design ? computeScores(design) : null;

				lines.push(`### ${item.year ?? ''} ${item.make} ${item.model}`);
				lines.push(`- Asking Price: ${item.last_asking_price ? formatCurrency(item.last_asking_price) : 'Unknown'}`);
				lines.push(`- Location: ${[item.last_location_city, item.last_location_state].filter(Boolean).join(', ') || 'Unknown'}`);
				lines.push(`- Status: ${formatLabel(item.status)}`);
				if (scores) {
					const key = useCaseToScore[useCase] ?? 'score_bluewater';
					lines.push(`- ${formatLabel(useCase)} Score: ${scores[key]}/100`);
					lines.push(`- Bluewater Score: ${scores.score_bluewater}/100`);
				}
				lines.push('');
			}
		}

		lines.push(
			'## Analysis Requested',
			`1. Compare these boats for ${useCaseLabels[useCase] ?? useCase} suitability`,
			`2. Assess each boat's fit for a ${formatLabel(experience).toLowerCase()} sailor`,
			`3. Flag any concerns for ${waters}`,
			'4. Evaluate the asking prices — are they reasonable?',
			'5. Rank them from best to worst fit and explain why',
			'6. Suggest what to look for in a pre-purchase survey for each'
		);

		return lines.join('\n');
	}

	const prompt = $derived(buildAnalysisPrompt());

	function statusBadge(status: string): string {
		switch (status) {
			case 'active': return 'bg-green-50 text-green-700';
			case 'price_changed': return 'bg-yellow-50 text-yellow-700';
			case 'delisted': case 'sold': return 'bg-red-50 text-red-700';
			default: return 'bg-gray-100 text-gray-600';
		}
	}

	const steps = [
		{ num: 1, label: 'Use Case' },
		{ num: 2, label: 'Preferences' },
		{ num: 3, label: 'Designs' },
		{ num: 4, label: 'Your Listings' }
	];
</script>

<div class="space-y-8">
	<!-- Step indicator -->
	<div class="flex items-center justify-center gap-2">
		{#each steps as s}
			<button
				onclick={() => { if (s.num <= step || (s.num <= 3 && useCase) || (s.num === 4 && useCase)) step = s.num; }}
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

	<!-- Step 2: Preferences (optional) -->
	{#if step === 2}
		<section>
			<div class="mb-6 text-center">
				<h1 class="mb-2 text-2xl font-bold text-gray-900">Boat Preferences</h1>
				<p class="mx-auto max-w-xl text-sm text-gray-500">
					Optionally narrow down designs based on what you want (or don't want) in a boat.
				</p>
			</div>
			<PreferencesForm
				{preferences}
				onchange={handlePrefsChange}
				onnext={() => (step = 3)}
				onskip={() => (step = 3)}
			/>
		</section>
	{/if}

	<!-- Step 3: Explore Designs -->
	{#if step === 3}
		<section>
			<div class="mb-6">
				<h1 class="mb-2 text-2xl font-bold text-gray-900">
					Top Designs for {formatLabel(useCase)}
				</h1>
				<p class="text-sm text-gray-500">
					Ranked for {formatLabel(useCase)} ({formatLabel(experience)} level). Click a design to see full specs, scores, and live listings.
				</p>
			</div>

			<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
				{#each rankedDesigns() as { boat, scores, composite }, i}
					{@const score = composite}
					<a
						href="/boats/{boat.id}?uc={useCase}&exp={experience}&waters={encodeURIComponent(waters)}"
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
								<div class="text-2xl font-bold {scoreTextColor(score)}">{score}</div>
								<div class="text-xs text-gray-400">/ 100</div>
							</div>
						</div>

						<div class="mt-3 flex items-center gap-2">
							<div class="h-2 flex-1 overflow-hidden rounded-full bg-gray-200">
								<div class="h-full rounded-full {scoreBarColor(score)}" style="width: {score}%"></div>
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
					onclick={() => (step = 4)}
					class="rounded-lg bg-blue-600 px-6 py-3 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
				>
					Review Your Listings
				</button>
			</div>
		</section>
	{/if}

	<!-- Step 4: Your Listings + Prompt -->
	{#if step === 4}
		<section class="space-y-8">
			<div>
				<h1 class="mb-2 text-2xl font-bold text-gray-900">Your Tracked Listings</h1>
				<p class="text-sm text-gray-500">
					Review the listings you're tracking and generate a Claude analysis prompt.
				</p>
			</div>

			{#if !user}
				<div class="rounded-lg border border-yellow-200 bg-yellow-50 p-8 text-center">
					<p class="text-sm text-yellow-800">Sign in to see your tracked listings.</p>
				</div>
			{:else if watchlistLoading}
				<div class="py-8 text-center">
					<div class="mx-auto h-6 w-6 animate-spin rounded-full border-4 border-gray-300 border-t-blue-500"></div>
				</div>
			{:else if watchlistItems.length === 0}
				<div class="rounded-lg border border-gray-200 bg-gray-50 p-8 text-center">
					<p class="text-gray-500">No tracked listings yet.</p>
					<p class="mt-2 text-sm text-gray-400">
						Go to a design page, search BoatTrader listings, and click "Track Listing" on any boat you're interested in.
					</p>
					<button
						onclick={() => (step = 3)}
						class="mt-4 rounded-lg bg-blue-600 px-5 py-2.5 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
					>
						Browse Designs
					</button>
				</div>
			{:else}
				<div class="space-y-3">
					{#each watchlistItems as item}
						<div class="rounded-lg border border-gray-200 bg-white p-4">
							<div class="flex items-start justify-between">
								<div>
									<div class="font-semibold text-gray-900">
										{item.year ?? ''} {item.make} {item.model}
									</div>
									<div class="mt-1 text-sm text-gray-600">
										{[item.last_location_city, item.last_location_state].filter(Boolean).join(', ')}
									</div>
									{#if item.last_checked_at}
										<div class="mt-1 text-xs text-gray-400">
											Last checked: {new Date(item.last_checked_at).toLocaleDateString()}
										</div>
									{/if}
								</div>
								<div class="flex flex-col items-end gap-2">
									{#if item.last_asking_price}
										<div class="text-lg font-bold text-blue-600">
											{formatCurrency(item.last_asking_price)}
										</div>
									{/if}
									<span class="rounded px-2 py-0.5 text-xs font-medium {statusBadge(item.status)}">
										{formatLabel(item.status)}
									</span>
								</div>
							</div>
							<div class="mt-3 flex items-center gap-3">
								{#if item.listing_url}
									<a
										href={item.listing_url}
										target="_blank"
										rel="noopener noreferrer"
										class="text-xs text-blue-600 hover:text-blue-800"
									>
										View on BoatTrader
									</a>
								{/if}
								<button
									onclick={() => removeItem(item.id)}
									class="text-xs text-red-500 hover:text-red-700"
								>
									Remove
								</button>
							</div>
						</div>
					{/each}
				</div>

				<!-- Generate Prompt -->
				<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
					<h2 class="mb-2 text-lg font-semibold text-gray-900">Generate Claude Analysis</h2>
					<p class="mb-4 text-sm text-gray-500">
						Get a detailed comparison of your {watchlistItems.length} tracked listing{watchlistItems.length !== 1 ? 's' : ''}
						for {useCaseLabels[useCase] ?? useCase}.
					</p>
					<button
						onclick={() => (showPrompt = !showPrompt)}
						class="rounded-lg bg-blue-600 px-5 py-2.5 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
					>
						{showPrompt ? 'Hide Prompt' : 'Generate Prompt'}
					</button>
				</div>

				{#if showPrompt}
					<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
						<div class="mb-3 flex items-center justify-between">
							<h3 class="text-sm font-semibold text-gray-700">Prompt</h3>
							<button
								onclick={() => navigator.clipboard.writeText(prompt)}
								class="rounded border border-gray-300 px-3 py-1 text-xs font-medium text-gray-600 hover:bg-gray-50 transition-colors"
							>
								Copy to Clipboard
							</button>
						</div>
						<pre class="max-h-96 overflow-auto rounded-lg bg-gray-50 p-4 text-sm text-gray-800 whitespace-pre-wrap">{prompt}</pre>
					</div>
				{/if}
			{/if}
		</section>
	{/if}
</div>
