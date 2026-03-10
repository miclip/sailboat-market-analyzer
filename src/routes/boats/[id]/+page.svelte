<script lang="ts">
	import { page } from '$app/state';
	import { onMount } from 'svelte';
	import { boats } from '$lib/seed-data';
	import { computeScores } from '$lib/scoring';
	import { buildPrompt } from '$lib/prompt-builder';
	import { supabase } from '$lib/supabase';
	import { scoreComps } from '$lib/comp-finder';
	import type { Boat, BoatScores, Listing, Comp, ScoreDimension, PromptListingSummary, MarketSnapshot } from '$lib/types';
	import type { CompScore } from '$lib/comp-finder';
	import type { BoatTraderListing } from '$lib/boattrader';
	import BoatCard from '$lib/components/BoatCard.svelte';
	import ScoreRadar from '$lib/components/ScoreRadar.svelte';
	import ScoreBreakdown from '$lib/components/ScoreBreakdown.svelte';
	import PromptOutput from '$lib/components/PromptOutput.svelte';
	import CompList from '$lib/components/CompList.svelte';
	import SalePriceForm from '$lib/components/SalePriceForm.svelte';
	import { formatCurrency, formatLabel } from '$lib/utils';
	import BoatTraderListings from '$lib/components/BoatTraderListings.svelte';

	const boat = $derived(boats.find((b) => b.id === page.params.id));

	// Extract model name by removing manufacturer prefix from design_name
	const btModel = $derived(
		boat ? boat.design_name.replace(new RegExp('^' + boat.manufacturer + '\\s*', 'i'), '') : ''
	);
	const scores = $derived(boat ? computeScores(boat) : null);

	// Map short use case keys to prompt-friendly labels
	const useCaseLabels: Record<string, string> = {
		bluewater: 'bluewater passage-making',
		pacific: 'Pacific circuit',
		coastal: 'coastal cruising',
		liveaboard: 'liveaboard cruiser',
		singlehand: 'singlehanded sailing',
		circumnavigation: 'circumnavigation'
	};

	// Map use case keys to score dimension keys
	const useCaseToDimension: Record<string, string> = {
		bluewater: 'bluewater',
		pacific: 'bluewater',
		coastal: 'coastal_cruising',
		liveaboard: 'liveaboard',
		singlehand: 'singlehand',
		circumnavigation: 'bluewater'
	};

	const qsUc = page.url.searchParams.get('uc') ?? '';
	const qsExp = page.url.searchParams.get('exp') ?? '';
	const qsWaters = page.url.searchParams.get('waters') ?? '';
	const qsPrefs = page.url.searchParams.get('prefs') ?? '';
	const qsSid = page.url.searchParams.get('sid') ?? '';

	// Build back link preserving all state
	const backParams = new URLSearchParams();
	backParams.set('step', '3');
	if (qsUc) backParams.set('uc', qsUc);
	if (qsExp) backParams.set('exp', qsExp);
	if (qsWaters) backParams.set('waters', qsWaters);
	if (qsPrefs) backParams.set('prefs', qsPrefs);
	if (qsSid) backParams.set('sid', qsSid);
	const backHref = `/?${backParams.toString()}`;

	let showPrompt = $state(false);
	let useCase = $state(useCaseLabels[qsUc] ?? 'bluewater passage-making');
	let experience = $state(qsExp || 'intermediate');
	let targetWaters = $state(qsWaters || 'Pacific Ocean');
	const scoreDimension = (useCaseToDimension[qsUc] ?? 'bluewater') as ScoreDimension;

	let listings = $state<Listing[]>([]);
	let reportedComps = $state<Comp[]>([]);
	let compScores = $state<CompScore[]>([]);
	let loadingListings = $state(true);
	let btListings = $state<BoatTraderListing[]>([]);
	let snapshot = $state<MarketSnapshot | null>(null);

	function btToPromptListings(bts: BoatTraderListing[]): PromptListingSummary[] {
		return bts.map((bt) => ({
			url: bt.url,
			year: bt.year,
			asking_price: bt.priceUSD ?? undefined,
			location: [bt.city, bt.state].filter(Boolean).join(', ') || undefined,
			engine_hours: bt.engineHours ?? undefined,
			engine_info: [bt.engineMake, bt.engineModel, bt.engineHp ? `${bt.engineHp}hp` : ''].filter(Boolean).join(' ') || undefined,
			hull_material: bt.hullMaterial ?? undefined,
			description: bt.description ?? undefined
		}));
	}

	const prompt = $derived(
		boat && scores
			? buildPrompt({
					boat,
					scores,
					listing: listings[0],
					activeListings: btListings.length > 0 ? btToPromptListings(btListings) : undefined,
					comps: reportedComps.length > 0 ? reportedComps : undefined,
					use_case_primary: useCase,
					experience_level: experience,
					target_waters: targetWaters
				})
			: ''
	);

	onMount(async () => {
		if (!boat) return;

		// Fetch listings for this boat design
		const { data: listingData } = await supabase
			.from('listings')
			.select('*')
			.eq('boat_id', boat.id)
			.order('created_at', { ascending: false });

		listings = listingData ?? [];

		// Score comps if we have listings
		if (listings.length > 1) {
			compScores = scoreComps(listings[0], listings, boat.year_range_start, boat.year_range_end);
		}

		// Fetch reported sale prices for these listings
		if (listings.length > 0) {
			const listingIds = listings.map((l) => l.id);
			const { data: compData } = await supabase
				.from('comps')
				.select('*')
				.in('listing_id', listingIds)
				.order('submitted_at', { ascending: false });

			reportedComps = compData ?? [];
		}

		// Fetch latest market snapshot
		const { data: snapshotData } = await supabase
			.from('market_snapshots')
			.select('*')
			.eq('boat_design_id', boat.id)
			.order('snapshot_date', { ascending: false })
			.limit(1)
			.maybeSingle();

		snapshot = snapshotData as MarketSnapshot | null;

		loadingListings = false;
	});

	let showSalePriceForm = $state<string | null>(null);
</script>

{#if boat && scores}
	<div class="space-y-8">
		<div>
			<a href={backHref} class="mb-4 inline-block text-sm text-blue-600 hover:text-blue-800">
				&larr; Back to Rankings
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
			<ScoreBreakdown {scores} initialDimension={scoreDimension} />
		</div>

		<!-- Market snapshot -->
		{#if snapshot && snapshot.listing_count > 0}
			<div class="rounded-lg border border-blue-200 bg-blue-50 px-5 py-4">
				<div class="flex items-center justify-between">
					<div>
						<p class="text-sm font-medium text-blue-900">
							{snapshot.listing_count} currently for sale
							{#if snapshot.min_price && snapshot.max_price}
								({formatCurrency(snapshot.min_price)}–{formatCurrency(snapshot.max_price)})
							{/if}
						</p>
						<div class="mt-1 flex flex-wrap gap-4 text-xs text-blue-700">
							{#if snapshot.median_price}
								<span>Median: {formatCurrency(snapshot.median_price)}</span>
							{/if}
							{#if snapshot.avg_days_on_market != null}
								<span>Avg days on market: {snapshot.avg_days_on_market}</span>
							{/if}
						</div>
					</div>
					<span class="text-xs text-blue-500">as of {snapshot.snapshot_date}</span>
				</div>
			</div>
		{/if}

		<!-- BoatTrader listings -->
		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-4 text-lg font-semibold text-gray-900">For Sale on BoatTrader</h2>
			<BoatTraderListings make={boat.manufacturer} model={btModel} boatDesignId={boat.id} sessionId={qsSid || null} onresults={(results) => { btListings = results; }} />
		</div>

		<!-- Community listings section -->
		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<div class="mb-4 flex items-center justify-between">
				<h2 class="text-lg font-semibold text-gray-900">Active Listings</h2>
				<a
					href="/listings/submit"
					class="text-sm text-blue-600 hover:text-blue-800"
				>
					Submit a listing
				</a>
			</div>

			{#if loadingListings}
				<div class="py-6 text-center">
					<div class="mx-auto h-6 w-6 animate-spin rounded-full border-4 border-gray-300 border-t-blue-500"></div>
				</div>
			{:else if listings.length === 0}
				<p class="text-sm text-gray-500">No listings yet for this design.</p>
			{:else}
				<div class="space-y-3">
					{#each listings as listing}
						<div class="rounded-lg border border-gray-100 bg-gray-50 p-4">
							<div class="flex items-start justify-between">
								<div>
									{#if listing.asking_price}
										<div class="text-lg font-bold text-blue-600">{formatCurrency(listing.asking_price)}</div>
									{/if}
									<div class="mt-1 text-sm text-gray-600">
										{[listing.location_city, listing.location_state].filter(Boolean).join(', ') || 'Location unknown'}
										{#if listing.location_market}
											&middot; {formatLabel(listing.location_market)}
										{/if}
									</div>
									<div class="mt-1 text-xs text-gray-500">
										{#if listing.condition_tier}
											{formatLabel(listing.condition_tier)}
										{/if}
										{#if listing.engine_hours != null}
											&middot; {listing.engine_hours} engine hrs
										{/if}
										{#if listing.rigging_age_years != null}
											&middot; Rigging: {listing.rigging_age_years}yr
										{/if}
									</div>
								</div>
								<div class="flex flex-col items-end gap-2">
									<span
										class="rounded px-2 py-0.5 text-xs font-medium
											{listing.status === 'active'
											? 'bg-green-50 text-green-700'
											: listing.status === 'sold'
												? 'bg-gray-100 text-gray-600'
												: 'bg-yellow-50 text-yellow-700'}"
									>
										{formatLabel(listing.status)}
									</span>
									{#if listing.yachtworld_url}
										<a
											href={listing.yachtworld_url}
											target="_blank"
											rel="noopener noreferrer"
											class="text-xs text-blue-600 hover:text-blue-800"
										>
											View on YachtWorld
										</a>
									{/if}
									<button
										onclick={() =>
											(showSalePriceForm =
												showSalePriceForm === listing.id ? null : listing.id)}
										class="text-xs text-gray-500 hover:text-blue-600"
									>
										Report sale price
									</button>
								</div>
							</div>
							{#if showSalePriceForm === listing.id}
								<div class="mt-4 border-t border-gray-200 pt-4">
									<SalePriceForm listingId={listing.id} />
								</div>
							{/if}
						</div>
					{/each}
				</div>
			{/if}
		</div>

		<!-- Comp data section -->
		{#if !loadingListings && (compScores.length > 0 || reportedComps.length > 0)}
			<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
				<h2 class="mb-4 text-lg font-semibold text-gray-900">Comparable Sales</h2>
				<CompList {compScores} {reportedComps} />
			</div>
		{/if}

		<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
			<h2 class="mb-2 text-lg font-semibold text-gray-900">Get Expert Analysis</h2>
			<p class="mb-3 text-sm text-gray-600">
				Generate a prompt with this design's specs, listings, and scores. Copy and paste it into
				<a href="https://claude.ai" target="_blank" rel="noopener noreferrer" class="font-medium text-blue-600 hover:text-blue-800">claude.ai</a>
				for a detailed buying analysis.
			</p>
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
