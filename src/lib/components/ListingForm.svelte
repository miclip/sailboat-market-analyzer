<script lang="ts">
	import { supabase } from '$lib/supabase';
	import { getUser } from '$lib/auth.svelte';
	import { boats } from '$lib/seed-data';
	import type { ConditionTier, LocationMarket, SailsCondition } from '$lib/types';

	let boatId = $state('');
	let yachtworldUrl = $state('');
	let askingPrice = $state<number | undefined>();
	let listDate = $state('');
	let locationCity = $state('');
	let locationState = $state('');
	let locationMarket = $state<LocationMarket | ''>('');
	let engineHours = $state<number | undefined>();
	let conditionTier = $state<ConditionTier | ''>('');
	let riggingAgeYears = $state<number | undefined>();
	let sailsCondition = $state<SailsCondition | ''>('');
	let recentRefit = $state(false);
	let refitNotes = $state('');

	let submitting = $state(false);
	let submitError = $state('');
	let submitSuccess = $state(false);

	const user = $derived(getUser());

	const markets: { value: LocationMarket; label: string }[] = [
		{ value: 'puget_sound', label: 'Puget Sound' },
		{ value: 'san_francisco_bay', label: 'San Francisco Bay' },
		{ value: 'socal', label: 'Southern California' },
		{ value: 'gulf_coast', label: 'Gulf Coast' },
		{ value: 'east_coast_ne', label: 'East Coast NE' },
		{ value: 'east_coast_se', label: 'East Coast SE' },
		{ value: 'great_lakes', label: 'Great Lakes' },
		{ value: 'international', label: 'International' }
	];

	const conditions: { value: ConditionTier; label: string }[] = [
		{ value: 'offshore_ready', label: 'Offshore Ready' },
		{ value: 'good', label: 'Good' },
		{ value: 'fair', label: 'Fair' },
		{ value: 'project', label: 'Project' }
	];

	const sailConditions: { value: SailsCondition; label: string }[] = [
		{ value: 'new', label: 'New' },
		{ value: 'good', label: 'Good' },
		{ value: 'fair', label: 'Fair' },
		{ value: 'worn', label: 'Worn' }
	];

	async function handleSubmit(e: Event) {
		e.preventDefault();
		if (!user) return;
		if (!boatId) {
			submitError = 'Please select a boat design.';
			return;
		}

		submitting = true;
		submitError = '';

		const { error } = await supabase.from('listings').insert({
			boat_id: boatId,
			yachtworld_url: yachtworldUrl || null,
			asking_price: askingPrice ?? null,
			list_date: listDate || null,
			location_city: locationCity || null,
			location_state: locationState || null,
			location_market: locationMarket || null,
			engine_hours: engineHours ?? null,
			condition_tier: conditionTier || null,
			rigging_age_years: riggingAgeYears ?? null,
			sails_condition: sailsCondition || null,
			recent_refit: recentRefit,
			refit_notes: refitNotes || null,
			submitted_by: user.id
		});

		submitting = false;
		if (error) {
			submitError = error.message;
		} else {
			submitSuccess = true;
		}
	}
</script>

{#if !user}
	<div class="rounded-lg border border-yellow-200 bg-yellow-50 p-6 text-center">
		<p class="text-sm text-yellow-800">Sign in to submit a listing.</p>
	</div>
{:else if submitSuccess}
	<div class="rounded-lg border border-green-200 bg-green-50 p-6 text-center">
		<p class="mb-2 font-semibold text-green-800">Listing submitted!</p>
		<button
			onclick={() => {
				submitSuccess = false;
				boatId = '';
				yachtworldUrl = '';
				askingPrice = undefined;
				listDate = '';
				locationCity = '';
				locationState = '';
				locationMarket = '';
				engineHours = undefined;
				conditionTier = '';
				riggingAgeYears = undefined;
				sailsCondition = '';
				recentRefit = false;
				refitNotes = '';
			}}
			class="text-sm text-green-700 underline"
		>
			Submit another
		</button>
	</div>
{:else}
	<form onsubmit={handleSubmit} class="space-y-6">
		<!-- Boat design -->
		<div>
			<label for="boat-design" class="mb-1 block text-sm font-medium text-gray-700">Boat Design *</label>
			<select
				id="boat-design"
				bind:value={boatId}
				required
				class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
			>
				<option value="">Select a design...</option>
				{#each boats as boat}
					<option value={boat.id}>{boat.design_name} ({boat.manufacturer})</option>
				{/each}
			</select>
		</div>

		<!-- YachtWorld URL -->
		<div>
			<label for="yw-url" class="mb-1 block text-sm font-medium text-gray-700">YachtWorld URL</label>
			<input
				id="yw-url"
				type="url"
				bind:value={yachtworldUrl}
				placeholder="https://www.yachtworld.com/yacht/..."
				class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
			/>
		</div>

		<!-- Price and date -->
		<div class="grid gap-4 sm:grid-cols-2">
			<div>
				<label for="asking-price" class="mb-1 block text-sm font-medium text-gray-700">Asking Price ($)</label>
				<input
					id="asking-price"
					type="number"
					bind:value={askingPrice}
					placeholder="185000"
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				/>
			</div>
			<div>
				<label for="list-date" class="mb-1 block text-sm font-medium text-gray-700">List Date</label>
				<input
					id="list-date"
					type="date"
					bind:value={listDate}
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				/>
			</div>
		</div>

		<!-- Location -->
		<div class="grid gap-4 sm:grid-cols-3">
			<div>
				<label for="city" class="mb-1 block text-sm font-medium text-gray-700">City</label>
				<input
					id="city"
					type="text"
					bind:value={locationCity}
					placeholder="Seattle"
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				/>
			</div>
			<div>
				<label for="state" class="mb-1 block text-sm font-medium text-gray-700">State</label>
				<input
					id="state"
					type="text"
					bind:value={locationState}
					placeholder="WA"
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				/>
			</div>
			<div>
				<label for="market" class="mb-1 block text-sm font-medium text-gray-700">Market</label>
				<select
					id="market"
					bind:value={locationMarket}
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				>
					<option value="">Select...</option>
					{#each markets as m}
						<option value={m.value}>{m.label}</option>
					{/each}
				</select>
			</div>
		</div>

		<!-- Condition -->
		<div class="grid gap-4 sm:grid-cols-3">
			<div>
				<label for="condition" class="mb-1 block text-sm font-medium text-gray-700">Condition</label>
				<select
					id="condition"
					bind:value={conditionTier}
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				>
					<option value="">Select...</option>
					{#each conditions as c}
						<option value={c.value}>{c.label}</option>
					{/each}
				</select>
			</div>
			<div>
				<label for="engine-hours" class="mb-1 block text-sm font-medium text-gray-700">Engine Hours</label>
				<input
					id="engine-hours"
					type="number"
					bind:value={engineHours}
					placeholder="2500"
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				/>
			</div>
			<div>
				<label for="rigging-age" class="mb-1 block text-sm font-medium text-gray-700">Rigging Age (years)</label>
				<input
					id="rigging-age"
					type="number"
					bind:value={riggingAgeYears}
					placeholder="8"
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				/>
			</div>
		</div>

		<!-- Sails and refit -->
		<div class="grid gap-4 sm:grid-cols-2">
			<div>
				<label for="sails" class="mb-1 block text-sm font-medium text-gray-700">Sails Condition</label>
				<select
					id="sails"
					bind:value={sailsCondition}
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				>
					<option value="">Select...</option>
					{#each sailConditions as s}
						<option value={s.value}>{s.label}</option>
					{/each}
				</select>
			</div>
			<div class="flex items-end gap-3 pb-1">
				<label class="flex items-center gap-2 text-sm text-gray-700">
					<input type="checkbox" bind:checked={recentRefit} class="rounded" />
					Recent Refit
				</label>
			</div>
		</div>

		{#if recentRefit}
			<div>
				<label for="refit-notes" class="mb-1 block text-sm font-medium text-gray-700">Refit Notes</label>
				<textarea
					id="refit-notes"
					bind:value={refitNotes}
					rows={3}
					placeholder="Describe the refit scope..."
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				></textarea>
			</div>
		{/if}

		{#if submitError}
			<div class="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
				{submitError}
			</div>
		{/if}

		<button
			type="submit"
			disabled={submitting}
			class="rounded-lg bg-blue-600 px-6 py-2.5 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50 transition-colors"
		>
			{submitting ? 'Submitting...' : 'Submit Listing'}
		</button>
	</form>
{/if}
