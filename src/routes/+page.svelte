<script lang="ts">
	import { page } from '$app/state';
	import { afterNavigate } from '$app/navigation';
	import { boats } from '$lib/seed-data';
	import { computeScores } from '$lib/scoring';
	import { supabase } from '$lib/supabase';
	import type { Boat, BoatScores, WatchlistItem, UserPreferences } from '$lib/types';
	import { defaultPreferences } from '$lib/types';
	import UseCaseForm from '$lib/components/UseCaseForm.svelte';
	import PreferencesForm from '$lib/components/PreferencesForm.svelte';
	import SessionBar from '$lib/components/SessionBar.svelte';
	import { getUser } from '$lib/auth.svelte';
	import { getActiveSessionId, setActiveSessionId as setSessionId, saveSessionDebounced } from '$lib/session.svelte';
	import { formatLabel, formatCurrency, formatNumber } from '$lib/utils';
	import PromptOutput from '$lib/components/PromptOutput.svelte';

	interface ScoredBoat {
		boat: Boat;
		scores: BoatScores;
	}

	const scoredBoats: ScoredBoat[] = boats.map((b) => ({ boat: b, scores: computeScores(b) }));

	// Restore state from URL params (e.g. when navigating back from boat detail)
	function readUrlState() {
		const params = page.url.searchParams;
		return {
			step: Number(params.get('step')) || 0,
			uc: params.get('uc') ?? '',
			exp: params.get('exp') ?? '',
			waters: params.get('waters') ?? '',
			prefs: params.get('prefs'),
			sid: params.get('sid')
		};
	}

	const initial = readUrlState();
	if (initial.sid) setSessionId(initial.sid);

	let step = $state(initial.step >= 1 && initial.step <= 4 ? initial.step : 1);
	let useCase = $state(initial.uc || '');
	let experience = $state(initial.exp || '');
	let waters = $state(initial.waters || '');
	let preferences = $state<UserPreferences>(
		initial.prefs ? { ...defaultPreferences, ...JSON.parse(initial.prefs) } : { ...defaultPreferences }
	);

	// Handle client-side navigations (e.g. Home click, back from boat detail)
	// Skip the very first afterNavigate (initial page load) to avoid resetting state
	let navCount = 0;
	afterNavigate(({ to }) => {
		navCount++;
		if (navCount <= 1) return; // Skip initial load
		if (!to?.url) return;
		const params = to.url.searchParams;
		const qsStep = Number(params.get('step')) || 0;
		const qsUc = params.get('uc') ?? '';

		if (!qsStep && !qsUc) {
			// Fresh navigation with no params (e.g. Home click) — reset
			step = 1;
			useCase = '';
			experience = '';
			waters = '';
			preferences = { ...defaultPreferences };
			setSessionId(null);
			watchlistLoaded = false;
			watchlistItems = [];
			showPrompt = false;
		} else {
			// Restore state from params (e.g. back from boat detail)
			if (qsStep >= 1 && qsStep <= 4) step = qsStep;
			if (qsUc) useCase = qsUc;
			const qsExp = params.get('exp') ?? '';
			const qsWaters = params.get('waters') ?? '';
			const qsPrefs = params.get('prefs');
			const qsSid = params.get('sid');
			if (qsExp) experience = qsExp;
			if (qsWaters) waters = qsWaters;
			if (qsPrefs) preferences = { ...defaultPreferences, ...JSON.parse(qsPrefs) };
			if (qsSid) setSessionId(qsSid);
		}
	});

	// Build query string for preserving state across navigation
	function stateParams(): string {
		const p = new URLSearchParams();
		p.set('uc', useCase);
		p.set('exp', experience);
		p.set('waters', waters);
		// Only serialize non-default preferences
		const diff: Record<string, unknown> = {};
		for (const [k, v] of Object.entries(preferences)) {
			if (v !== (defaultPreferences as unknown as Record<string, unknown>)[k] && v != null) {
				diff[k] = v;
			}
		}
		if (Object.keys(diff).length > 0) {
			p.set('prefs', JSON.stringify(diff));
		}
		if (activeSessionId) {
			p.set('sid', activeSessionId);
		}
		return p.toString();
	}

	const user = $derived(getUser());
	const activeSessionId = $derived(getActiveSessionId());

	// Auto-save session state when it changes
	$effect(() => {
		const sid = activeSessionId;
		if (!sid) return;
		// Touch all reactive deps we want to track
		const _uc = useCase;
		const _exp = experience;
		const _wat = waters;
		const _prefs = preferences;
		const _step = step;
		saveSessionDebounced(sid, {
			use_case: _uc,
			experience: _exp,
			waters: _wat,
			preferences: _prefs,
			current_step: _step
		});
	});

	function handleSessionLoad(state: { use_case: string; experience: string; waters: string; preferences: UserPreferences; current_step: number }) {
		useCase = state.use_case;
		experience = state.experience;
		waters = state.waters;
		preferences = state.preferences;

		// Infer the minimum step from session data, don't trust current_step
		// alone since it may have been corrupted by earlier auto-save bugs
		let inferredStep = 1;
		if (state.use_case) inferredStep = 3; // has use case → at least designs
		const savedStep = state.current_step >= 1 && state.current_step <= 4 ? state.current_step : 1;
		step = Math.max(savedStep, inferredStep);

		// Reset watchlist so it reloads for the new session
		watchlistLoaded = false;
		watchlistItems = [];
		showPrompt = false;
	}

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

	// Load watchlist when user is available and we reach step 4
	// Also reload when activeSessionId changes
	$effect(() => {
		// Touch activeSessionId so this effect re-runs on session switch
		const _sid = activeSessionId;
		if (user && step === 4 && !watchlistLoaded) {
			watchlistLoaded = true;
			loadWatchlist();
		}
	});

	async function loadWatchlist() {
		if (!user) return;
		watchlistLoading = true;
		let query = supabase
			.from('watchlist')
			.select('*')
			.eq('user_id', user.id);
		if (activeSessionId) {
			// Show items for this session plus any unlinked items
			query = query.or(`session_id.eq.${activeSessionId},session_id.is.null`);
		}
		const { data } = await query.order('created_at', { ascending: false });
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

	function matchDesign(make: string, model: string): Boat | undefined {
		const makeLower = make.toLowerCase();
		const modelLower = model.toLowerCase();
		// Filter to same manufacturer
		const sameMake = boats.filter((b) => b.manufacturer.toLowerCase() === makeLower);
		if (sameMake.length === 0) return undefined;

		// Try exact match: design_name equals "Make Model"
		const fullName = `${makeLower} ${modelLower}`;
		const exact = sameMake.find((b) => b.design_name.toLowerCase() === fullName);
		if (exact) return exact;

		// Try: design_name contains the model, pick the best (shortest name that matches)
		const candidates = sameMake
			.filter((b) => b.design_name.toLowerCase().includes(modelLower))
			.sort((a, b) => a.design_name.length - b.design_name.length);
		if (candidates.length > 0) return candidates[0];

		// Try: model contains the design_name's model part
		const reverse = sameMake
			.filter((b) => {
				const designModel = b.design_name.toLowerCase().replace(makeLower, '').trim();
				return designModel && modelLower.includes(designModel);
			})
			.sort((a, b) => b.design_name.length - a.design_name.length);
		if (reverse.length > 0) return reverse[0];

		return undefined;
	}

	function buildAnalysisPrompt(): string {
		const ucLabel = useCaseLabels[useCase] ?? useCase;
		const expLabel = formatLabel(experience).toLowerCase();
		const scoreDimKey = useCaseToScore[useCase] ?? 'score_bluewater';
		// Map score key to breakdown key
		const breakdownKey = scoreDimKey.replace('score_', '');

		const lines: string[] = [
			`You are an expert marine surveyor and sailing advisor helping a sailor evaluate boats for purchase. Where listing URLs are provided, browse them to extract engine hours, rigging condition, refit history, sail inventory, and any details not listed below. Consider the total cost of ownership (purchase + delivery + refit to make passage-ready).`,
			'',
			'## Buyer Profile',
			`Primary Use Case: ${ucLabel}`,
			`Experience Level: ${expLabel}`,
			`Target Waters: ${waters}`,
		];

		// Add buyer preferences
		const prefLines: string[] = [];
		if (preferences.max_budget) {
			prefLines.push(`Max Budget (purchase only): ${formatCurrency(preferences.max_budget)}`);
		}
		if (preferences.cockpit_type) {
			prefLines.push(`Cockpit Preference: ${formatLabel(preferences.cockpit_type)}`);
		}
		if (preferences.rig_preference) {
			prefLines.push(`Rig Preference: ${formatLabel(preferences.rig_preference)}`);
		}
		if (preferences.galley_preference) {
			prefLines.push(`Galley Preference: ${formatLabel(preferences.galley_preference)}`);
		}
		if (preferences.min_loa_ft || preferences.max_loa_ft) {
			const min = preferences.min_loa_ft ? `${preferences.min_loa_ft}ft` : 'any';
			const max = preferences.max_loa_ft ? `${preferences.max_loa_ft}ft` : 'any';
			prefLines.push(`LOA Range: ${min} – ${max}`);
		}
		if (preferences.no_teak_decks) prefLines.push('Excluding: teak decks');
		if (preferences.no_canoe_stern) prefLines.push('Excluding: canoe stern');
		if (preferences.prefer_keel_stepped) prefLines.push('Preference: keel-stepped mast');

		if (prefLines.length > 0) {
			lines.push('', '## Buyer Preferences');
			for (const pl of prefLines) lines.push(pl);
		}

		if (watchlistItems.length > 0) {
			lines.push('', '## Boats Under Consideration');
			for (const item of watchlistItems) {
				const design = matchDesign(item.make, item.model);
				const scores = design ? computeScores(design) : null;

				lines.push('', `### ${item.year ?? ''} ${item.make} ${item.model}`);
				if (item.listing_url) {
					lines.push(`- Listing URL: ${item.listing_url}`);
				}
				lines.push(`- Asking Price: ${item.last_asking_price ? formatCurrency(item.last_asking_price) : 'Unknown'}`);
				lines.push(`- Location: ${[item.last_location_city, item.last_location_state].filter(Boolean).join(', ') || 'Unknown'}`);
				lines.push(`- Status: ${formatLabel(item.status)}`);

				if (design) {
					lines.push(`- LOA: ${design.length_ft ?? '?'}ft | Beam: ${design.beam_ft ?? '?'}ft | LWL: ${design.lwl_ft ?? '?'}ft`);
					lines.push(`- Displacement: ${design.displacement_lbs ? formatNumber(design.displacement_lbs) + 'lbs' : '?'} | Ballast: ${design.ballast_lbs ? formatNumber(design.ballast_lbs) + 'lbs' : '?'} (${design.ballast_ratio ? (design.ballast_ratio * 100).toFixed(0) + '%' : '?'})`);
					lines.push(`- D/L: ${design.displacement_length_ratio?.toFixed(0) ?? '?'} | SA/D: ${design.sa_displacement_ratio?.toFixed(1) ?? '?'} | Sail Area: ${design.sail_area_sqft ? formatNumber(design.sail_area_sqft) + 'sqft' : '?'}`);
					lines.push(`- Capsize Screening: ${design.capsize_screening_value?.toFixed(2) ?? '?'} (< 2.0 offshore capable) | Motion Comfort: ${design.motion_comfort_ratio?.toFixed(1) ?? '?'} (30+ good for bluewater)`);
					lines.push(`- Rig: ${design.rig_type ? formatLabel(design.rig_type) : '?'} | Keel: ${design.keel_type ? formatLabel(design.keel_type) : '?'} | Rudder: ${design.rudder_type ? formatLabel(design.rudder_type) : '?'}`);
					lines.push(`- Cockpit: ${design.cockpit_type ? formatLabel(design.cockpit_type) : '?'} | Hull: ${design.hull_type ? formatLabel(design.hull_type) : '?'} | Stern: ${design.stern_type ? formatLabel(design.stern_type) : '?'}`);
					lines.push(`- Mast: ${design.mast_step ? formatLabel(design.mast_step) : '?'} | Backstay: ${design.has_backstay == null ? '?' : design.has_backstay ? 'Yes' : 'No'} | Teak Decks: ${design.has_teak_decks == null ? '?' : design.has_teak_decks ? 'Yes' : 'No'}`);
					if (design.cabins || design.berths || design.sea_berths) {
						lines.push(`- Cabins: ${design.cabins ?? '?'} | Berths: ${design.berths ?? '?'} | Sea Berths: ${design.sea_berths ?? '?'}`);
					}
					if (design.notes) {
						lines.push(`- Notes: ${design.notes}`);
					}
				}

				if (scores) {
					const primaryScore = scores[scoreDimKey as keyof typeof scores] as number;
					lines.push(`- ${formatLabel(useCase)} Score: ${primaryScore}/100`);
					lines.push(`- Bluewater Score: ${scores.score_bluewater}/100`);

					// Include score breakdown for the primary use case
					const breakdown = scores.score_breakdown?.[breakdownKey];
					if (breakdown && breakdown.length > 0) {
						lines.push(`- Score Factors (${formatLabel(useCase)}):`);
						for (const factor of breakdown) {
							lines.push(`  - ${factor.factor}: ${factor.points}/${factor.weight} (${factor.value})`);
						}
					}
				}
			}
		}

		lines.push(
			'',
			'## Analysis Requested',
			`1. **Design Comparison**: Compare these boats for ${ucLabel} suitability. Explain how the score breakdowns above reveal each design's strengths and weaknesses.`,
			`2. **Experience Fit**: Assess each boat's fit for a ${expLabel} sailor — what will be challenging, what systems to learn first.`,
			`3. **Waters-Specific Concerns**: Flag any concerns specific to ${waters} — currents, tides, weather patterns, marina access for these boat sizes, cold/wet weather livability.`,
			`4. **Price Analysis**: Evaluate each asking price against current market data. For boats located far from ${waters}, estimate delivery costs (sailing, shipping, or trucking).`,
			'5. **Total Cost of Ownership**: For each boat, estimate the refit budget to make it passage-ready for the target waters. Consider age-appropriate items (standing rigging, electronics, engine, sails, safety gear).',
			'6. **Ranking**: Rank from best to worst fit considering the full picture (design suitability + price + condition + location + refit needs). Explain your reasoning.',
			'7. **Survey Focus**: List the 5 most critical pre-purchase survey items for each specific design and vintage.',
			'8. **Listing Deep-Dive**: For each listing URL, extract and summarize: engine hours, rigging age/condition, recent refits, sail inventory, electronics, safety equipment, and any red flags from the description or photos.',
			'9. **Alternatives**: If any of these boats have significant gaps for the use case, suggest 2-3 better-suited alternatives available in a similar price range.'
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
	<!-- Session bar -->
	<SessionBar
		{useCase}
		{experience}
		{waters}
		{preferences}
		currentStep={step}
		onload={handleSessionLoad}
	/>

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
		<section class="space-y-10">
			<div class="text-center">
				<h1 class="mb-3 text-3xl font-bold text-gray-900">Find the Right Boat for How You Sail</h1>
				<p class="mx-auto max-w-2xl text-lg text-gray-600">
					Buying a bluewater sailboat is a multi-year journey. This tool helps you evaluate designs, track listings, compare prices, and generate expert analysis prompts — all tailored to your specific use case.
				</p>
			</div>

			<!-- How it works -->
			<div class="mx-auto max-w-3xl">
				<div class="grid gap-4 sm:grid-cols-4">
					<div class="rounded-lg border border-gray-200 bg-white p-4 text-center">
						<div class="mx-auto mb-2 flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 text-sm font-bold text-blue-700">1</div>
						<h3 class="text-sm font-semibold text-gray-900">Define Use Case</h3>
						<p class="mt-1 text-xs text-gray-500">Tell us how you'll sail — bluewater, coastal, singlehanded, liveaboard</p>
					</div>
					<div class="rounded-lg border border-gray-200 bg-white p-4 text-center">
						<div class="mx-auto mb-2 flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 text-sm font-bold text-blue-700">2</div>
						<h3 class="text-sm font-semibold text-gray-900">Set Preferences</h3>
						<p class="mt-1 text-xs text-gray-500">Filter by cockpit type, rig, size, budget, and features you care about</p>
					</div>
					<div class="rounded-lg border border-gray-200 bg-white p-4 text-center">
						<div class="mx-auto mb-2 flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 text-sm font-bold text-blue-700">3</div>
						<h3 class="text-sm font-semibold text-gray-900">Explore & Track</h3>
						<p class="mt-1 text-xs text-gray-500">Browse ranked designs, search BoatTrader listings, and track the ones you like</p>
					</div>
					<div class="rounded-lg border border-gray-200 bg-white p-4 text-center">
						<div class="mx-auto mb-2 flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 text-sm font-bold text-blue-700">4</div>
						<h3 class="text-sm font-semibold text-gray-900">Get AI Analysis</h3>
						<p class="mt-1 text-xs text-gray-500">Generate a prompt for Claude to analyze your shortlist with design data and listing URLs</p>
					</div>
				</div>
				<div class="mt-4 text-center">
					<a href="/guide" class="text-sm text-blue-600 hover:text-blue-800">Read the full guide</a>
				</div>
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
						href="/boats/{boat.id}?{stateParams()}"
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
			<div class="flex items-start justify-between">
				<div>
					<h1 class="mb-2 text-2xl font-bold text-gray-900">Your Tracked Listings</h1>
					<p class="text-sm text-gray-500">
						Review the listings you're tracking and generate a Claude analysis prompt.
					</p>
				</div>
				{#if user && (watchlistItems.length > 0 || watchlistLoading)}
					<button
						onclick={() => loadWatchlist()}
						disabled={watchlistLoading}
						class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors disabled:opacity-50"
					>
						{watchlistLoading ? 'Refreshing...' : 'Refresh'}
					</button>
				{/if}
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
					<h2 class="mb-2 text-lg font-semibold text-gray-900">Get Expert Analysis</h2>
					<p class="mb-3 text-sm text-gray-600">
						Generate a detailed prompt comparing your {watchlistItems.length} tracked listing{watchlistItems.length !== 1 ? 's' : ''}
						for {useCaseLabels[useCase] ?? useCase}. The prompt includes your preferences, design specs, scoring breakdowns, and listing URLs.
					</p>
					<div class="mb-4 rounded-lg bg-blue-50 px-4 py-3 text-sm text-blue-800">
						<p class="font-medium">How to use</p>
						<ol class="mt-1.5 list-inside list-decimal space-y-1 text-blue-700">
							<li>Click "Generate Prompt" below to build your analysis prompt</li>
							<li>Copy it to your clipboard</li>
							<li>Paste it into <a href="https://claude.ai" target="_blank" rel="noopener noreferrer" class="font-medium underline hover:text-blue-900">claude.ai</a> or another AI assistant</li>
							<li>The AI will browse your listing URLs, extract details, and provide a comprehensive buying analysis</li>
						</ol>
					</div>
					<button
						onclick={() => (showPrompt = !showPrompt)}
						class="rounded-lg bg-blue-600 px-5 py-2.5 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
					>
						{showPrompt ? 'Hide Prompt' : 'Generate Prompt'}
					</button>
				</div>

				{#if showPrompt}
					<PromptOutput {prompt} />
				{/if}
			{/if}
		</section>
	{/if}
</div>
