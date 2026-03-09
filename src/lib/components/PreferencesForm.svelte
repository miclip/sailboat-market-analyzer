<script lang="ts">
	import type { UserPreferences } from '$lib/types';
	import { defaultPreferences } from '$lib/types';
	import { supabase } from '$lib/supabase';
	import { getUser } from '$lib/auth.svelte';
	import InfoTip from './InfoTip.svelte';

	interface Props {
		preferences: UserPreferences;
		onchange: (prefs: UserPreferences) => void;
		onnext: () => void;
		onskip: () => void;
	}

	let { preferences, onchange, onnext, onskip }: Props = $props();

	const user = $derived(getUser());
	let saving = $state(false);
	let saved = $state(false);
	let loading = $state(false);

	// Local copy for editing
	let prefs = $state<UserPreferences>({ ...defaultPreferences, ...preferences });

	// Load preferences from DB when user becomes available
	$effect(() => {
		if (user && !loading) {
			loading = true;
			loadPreferences();
		}
	});

	async function loadPreferences() {
		if (!user) return;
		const { data } = await supabase
			.from('user_preferences')
			.select('*')
			.eq('user_id', user.id)
			.maybeSingle();

		if (data) {
			prefs = { ...defaultPreferences, ...data };
			onchange(prefs);
		}
		loading = false;
	}

	async function savePreferences() {
		if (!user) return;
		saving = true;
		saved = false;

		const payload = {
			user_id: user.id,
			cockpit_type: prefs.cockpit_type || null,
			no_teak_decks: prefs.no_teak_decks,
			rig_preference: prefs.rig_preference || null,
			min_loa_ft: prefs.min_loa_ft || null,
			max_loa_ft: prefs.max_loa_ft || null,
			galley_preference: prefs.galley_preference || null,
			prefer_keel_stepped: prefs.prefer_keel_stepped,
			max_budget: prefs.max_budget || null,
			updated_at: new Date().toISOString()
		};

		const { error } = await supabase
			.from('user_preferences')
			.upsert(payload, { onConflict: 'user_id' });

		if (!error) {
			saved = true;
			setTimeout(() => (saved = false), 2000);
		}
		saving = false;
	}

	function update() {
		onchange({ ...prefs });
	}

	function clearAll() {
		prefs = { ...defaultPreferences };
		onchange(prefs);
	}
</script>

<div class="mx-auto max-w-2xl space-y-6">
	<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
		<div class="mb-6 flex items-center justify-between">
			<div>
				<h2 class="text-lg font-semibold text-gray-900">Your Preferences</h2>
				<p class="mt-1 text-sm text-gray-500">
					Optional filters to narrow down designs. Hard filters eliminate boats; soft preferences boost scores.
				</p>
			</div>
			<button onclick={clearAll} class="text-xs text-gray-400 hover:text-gray-600">Clear all</button>
		</div>

		<!-- Hard Filters -->
		<div class="mb-6">
			<h3 class="mb-3 text-sm font-semibold text-gray-700 uppercase tracking-wide">Hard Filters</h3>
			<div class="space-y-4">
				<!-- Cockpit Type -->
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-1">
						<span class="text-sm text-gray-700">Cockpit Type</span>
						<InfoTip text="Center cockpits have a protected helm and larger aft cabin, but aft cockpits offer better sail handling. Solar panels, wind turbines, and dinghy davits work better with center cockpits." />
					</div>
					<select
						class="rounded-lg border border-gray-300 px-3 py-1.5 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
						value={prefs.cockpit_type ?? ''}
						onchange={(e) => { prefs.cockpit_type = (e.currentTarget.value || null) as typeof prefs.cockpit_type; update(); }}
					>
						<option value="">No preference</option>
						<option value="center">Center cockpit</option>
						<option value="aft">Aft cockpit</option>
					</select>
				</div>

				<!-- No Teak Decks -->
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-1">
						<span class="text-sm text-gray-700">Exclude teak decks</span>
						<InfoTip text="Teak decks on older boats are a major maintenance burden. Recoring or removing them is expensive ($10k-30k+). Many buyers specifically avoid boats with aging teak decks." />
					</div>
					<label class="relative inline-flex cursor-pointer items-center">
						<input
							type="checkbox"
							class="peer sr-only"
							checked={prefs.no_teak_decks}
							onchange={() => { prefs.no_teak_decks = !prefs.no_teak_decks; update(); }}
						/>
						<div class="peer h-6 w-11 rounded-full bg-gray-200 after:absolute after:left-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-blue-600 peer-checked:after:translate-x-full peer-checked:after:border-white"></div>
					</label>
				</div>

				<!-- LOA Range -->
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-1">
						<span class="text-sm text-gray-700">Length range</span>
						<InfoTip text="Filter boats by overall length. Smaller boats are easier to handle and cheaper to maintain. Larger boats have more space and speed." />
					</div>
					<div class="flex items-center gap-2">
						<input
							type="number"
							placeholder="Min ft"
							class="w-20 rounded-lg border border-gray-300 px-2 py-1.5 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
							value={prefs.min_loa_ft ?? ''}
							oninput={(e) => { prefs.min_loa_ft = e.currentTarget.value ? Number(e.currentTarget.value) : null; update(); }}
						/>
						<span class="text-gray-400">-</span>
						<input
							type="number"
							placeholder="Max ft"
							class="w-20 rounded-lg border border-gray-300 px-2 py-1.5 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
							value={prefs.max_loa_ft ?? ''}
							oninput={(e) => { prefs.max_loa_ft = e.currentTarget.value ? Number(e.currentTarget.value) : null; update(); }}
						/>
					</div>
				</div>
			</div>
		</div>

		<!-- Soft Preferences -->
		<div class="mb-6">
			<h3 class="mb-3 text-sm font-semibold text-gray-700 uppercase tracking-wide">Soft Preferences</h3>
			<p class="mb-3 text-xs text-gray-400">These boost matching boats in the rankings but don't eliminate others.</p>
			<div class="space-y-4">
				<!-- Rig Preference -->
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-1">
						<span class="text-sm text-gray-700">Rig type</span>
						<InfoTip text="Sloop is simplest. Cutter adds an inner forestay for heavy weather flexibility. Ketch has two masts for varied sail plans. Cutter ketch combines both." />
					</div>
					<select
						class="rounded-lg border border-gray-300 px-3 py-1.5 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
						value={prefs.rig_preference ?? ''}
						onchange={(e) => { prefs.rig_preference = (e.currentTarget.value || null) as typeof prefs.rig_preference; update(); }}
					>
						<option value="">No preference</option>
						<option value="sloop">Sloop</option>
						<option value="cutter">Cutter</option>
						<option value="ketch">Ketch</option>
						<option value="cutter_ketch">Cutter ketch</option>
					</select>
				</div>

				<!-- Galley Preference -->
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-1">
						<span class="text-sm text-gray-700">Galley layout</span>
						<InfoTip text="U-shaped galleys let you brace while cooking at sea and offer the most counter space. Open linear layouts feel spacious at the dock but offer no bracing in rough conditions." />
					</div>
					<select
						class="rounded-lg border border-gray-300 px-3 py-1.5 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
						value={prefs.galley_preference ?? ''}
						onchange={(e) => { prefs.galley_preference = (e.currentTarget.value || null) as typeof prefs.galley_preference; update(); }}
					>
						<option value="">No preference</option>
						<option value="u_shaped">U-shaped</option>
						<option value="l_shaped">L-shaped</option>
						<option value="corridor">Corridor</option>
						<option value="open_linear">Open linear</option>
					</select>
				</div>

				<!-- Keel-Stepped Mast -->
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-1">
						<span class="text-sm text-gray-700">Prefer keel-stepped mast</span>
						<InfoTip text="Keel-stepped masts go through the deck to the hull for maximum strength. Important for offshore safety but adds complexity and weight." />
					</div>
					<label class="relative inline-flex cursor-pointer items-center">
						<input
							type="checkbox"
							class="peer sr-only"
							checked={prefs.prefer_keel_stepped}
							onchange={() => { prefs.prefer_keel_stepped = !prefs.prefer_keel_stepped; update(); }}
						/>
						<div class="peer h-6 w-11 rounded-full bg-gray-200 after:absolute after:left-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-blue-600 peer-checked:after:translate-x-full peer-checked:after:border-white"></div>
					</label>
				</div>
			</div>
		</div>

		<!-- Save / Actions -->
		<div class="flex items-center justify-between border-t border-gray-100 pt-4">
			<div>
				{#if user}
					<button
						onclick={savePreferences}
						disabled={saving}
						class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors disabled:opacity-50"
					>
						{saving ? 'Saving...' : saved ? 'Saved!' : 'Save Preferences'}
					</button>
				{:else}
					<span class="text-xs text-gray-400">Sign in to save preferences across sessions</span>
				{/if}
			</div>
			<div class="flex gap-3">
				<button
					onclick={onskip}
					class="rounded-lg border border-gray-300 px-5 py-2 text-sm font-medium text-gray-600 hover:bg-gray-50 transition-colors"
				>
					Skip
				</button>
				<button
					onclick={onnext}
					class="rounded-lg bg-blue-600 px-5 py-2 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
				>
					Apply & Continue
				</button>
			</div>
		</div>
	</div>
</div>
