<script lang="ts">
	import { supabase } from '$lib/supabase';
	import { boats } from '$lib/seed-data';
	import { formatCurrency, formatLabel } from '$lib/utils';
	import type { Listing } from '$lib/types';
	import { onMount } from 'svelte';

	let listings = $state<Listing[]>([]);
	let loading = $state(true);
	let error = $state('');
	let filterBoatId = $state('all');
	let filterStatus = $state('all');

	onMount(async () => {
		const { data, error: err } = await supabase
			.from('listings')
			.select('*')
			.order('created_at', { ascending: false });

		loading = false;
		if (err) {
			error = err.message;
		} else {
			listings = data ?? [];
		}
	});

	function boatName(boatId: string): string {
		return boats.find((b) => b.id === boatId)?.design_name ?? boatId;
	}

	const filtered = $derived(() => {
		let items = listings;
		if (filterBoatId !== 'all') {
			items = items.filter((l) => l.boat_id === filterBoatId);
		}
		if (filterStatus !== 'all') {
			items = items.filter((l) => l.status === filterStatus);
		}
		return items;
	});
</script>

<div class="space-y-6">
	<div class="flex items-center justify-between">
		<h1 class="text-2xl font-bold text-gray-900">Listings</h1>
		<a
			href="/listings/submit"
			class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
		>
			Submit Listing
		</a>
	</div>

	<div class="flex flex-wrap gap-4">
		<select
			bind:value={filterBoatId}
			class="rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
		>
			<option value="all">All Designs</option>
			{#each boats as boat}
				<option value={boat.id}>{boat.design_name}</option>
			{/each}
		</select>

		<select
			bind:value={filterStatus}
			class="rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
		>
			<option value="all">All Statuses</option>
			<option value="active">Active</option>
			<option value="sold">Sold</option>
			<option value="relisted">Relisted</option>
			<option value="withdrawn">Withdrawn</option>
		</select>
	</div>

	{#if loading}
		<div class="py-12 text-center">
			<div class="mx-auto h-8 w-8 animate-spin rounded-full border-4 border-gray-300 border-t-blue-500"></div>
		</div>
	{:else if error}
		<div class="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{error}</div>
	{:else if filtered().length === 0}
		<div class="rounded-lg border border-gray-200 bg-white p-12 text-center shadow-sm">
			<p class="text-gray-500">No listings yet. Be the first to submit one.</p>
		</div>
	{:else}
		<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
			{#each filtered() as listing}
				<div class="rounded-lg border border-gray-200 bg-white p-5 shadow-sm">
					<div class="mb-1 font-semibold text-gray-900">{boatName(listing.boat_id)}</div>
					{#if listing.asking_price}
						<div class="text-lg font-bold text-blue-600">{formatCurrency(listing.asking_price)}</div>
					{/if}
					<div class="mt-2 space-y-1 text-xs text-gray-500">
						{#if listing.location_city || listing.location_state}
							<div>{[listing.location_city, listing.location_state].filter(Boolean).join(', ')}</div>
						{/if}
						{#if listing.condition_tier}
							<div>Condition: {formatLabel(listing.condition_tier)}</div>
						{/if}
						{#if listing.engine_hours != null}
							<div>Engine: {listing.engine_hours} hrs</div>
						{/if}
						{#if listing.list_date}
							<div>Listed: {listing.list_date}</div>
						{/if}
					</div>
					<div class="mt-3 flex items-center justify-between">
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
								YachtWorld
							</a>
						{/if}
					</div>
				</div>
			{/each}
		</div>
	{/if}
</div>
