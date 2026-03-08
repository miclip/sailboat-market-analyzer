<script lang="ts">
	import { supabase } from '$lib/supabase';
	import { getUser } from '$lib/auth.svelte';
	import { formatCurrency } from '$lib/utils';
	import type { WatchlistItem } from '$lib/types';

	const user = $derived(getUser());

	let items = $state<WatchlistItem[]>([]);
	let loading = $state(true);
	let error = $state('');
	let refreshing = $state(false);
	let loaded = $state(false);

	let filterStatus = $state('all');

	$effect(() => {
		if (user && !loaded) {
			loaded = true;
			loadItems();
		}
		if (!user) {
			loading = false;
			loaded = false;
			items = [];
		}
	});

	async function loadItems() {
		loading = true;
		const { data, error: err } = await supabase
			.from('watchlist')
			.select('*')
			.eq('user_id', user!.id)
			.order('created_at', { ascending: false });

		loading = false;
		if (err) {
			error = err.message;
		} else {
			items = data ?? [];
		}
	}

	async function refreshAll() {
		if (!user || items.length === 0) return;
		refreshing = true;
		error = '';

		try {
			const { searchListings } = await import('$lib/boattrader');

			for (const item of items) {
				const result = await searchListings(item.make, item.model, 1, 50);
				const match = result.listings.find((l) => l.id === item.boattrader_id);

				const newStatus = match ? 'active' : 'not_found';
				const newPrice = match?.priceUSD ?? null;
				const priceChanged =
					newPrice !== null && item.last_asking_price !== null && newPrice !== item.last_asking_price;

				await supabase.from('price_history').insert({
					watchlist_id: item.id,
					asking_price: newPrice,
					status: match ? 'active' : 'not_found'
				});

				const updates: Record<string, unknown> = {
					last_checked_at: new Date().toISOString(),
					status: match ? (priceChanged ? 'price_changed' : 'active') : 'delisted'
				};
				if (newPrice !== null) {
					updates.last_asking_price = newPrice;
				}
				if (match) {
					updates.last_location_city = match.city || item.last_location_city;
					updates.last_location_state = match.state || item.last_location_state;
				}

				await supabase.from('watchlist').update(updates).eq('id', item.id);
			}

			await loadItems();
		} catch (e) {
			error = e instanceof Error ? e.message : 'Refresh failed';
		}

		refreshing = false;
	}

	async function removeItem(id: string) {
		await supabase.from('watchlist').delete().eq('id', id);
		items = items.filter((i) => i.id !== id);
	}

	function statusBadge(status: string): string {
		switch (status) {
			case 'active':
				return 'bg-green-50 text-green-700';
			case 'price_changed':
				return 'bg-yellow-50 text-yellow-700';
			case 'delisted':
			case 'sold':
				return 'bg-red-50 text-red-700';
			default:
				return 'bg-gray-100 text-gray-600';
		}
	}

	function statusLabel(status: string): string {
		switch (status) {
			case 'active':
				return 'Active';
			case 'price_changed':
				return 'Price Changed';
			case 'delisted':
				return 'Delisted';
			case 'sold':
				return 'Sold';
			default:
				return 'Unknown';
		}
	}

	const filtered = $derived(() => {
		if (filterStatus === 'all') return items;
		return items.filter((i) => i.status === filterStatus);
	});
</script>

<div class="space-y-6">
	<div class="flex items-center justify-between">
		<div>
			<h1 class="text-2xl font-bold text-gray-900">Tracked Listings</h1>
			<p class="mt-1 text-sm text-gray-500">Listings you're tracking from BoatTrader.</p>
		</div>
		{#if items.length > 0}
			<button
				onclick={refreshAll}
				disabled={refreshing}
				class="rounded-lg bg-blue-600 px-5 py-2.5 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50 transition-colors"
			>
				{refreshing ? 'Checking...' : 'Refresh All'}
			</button>
		{/if}
	</div>

	{#if items.length > 0}
		<div class="flex flex-wrap gap-4">
			<select
				bind:value={filterStatus}
				class="rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
			>
				<option value="all">All Statuses</option>
				<option value="active">Active</option>
				<option value="price_changed">Price Changed</option>
				<option value="delisted">Delisted</option>
				<option value="sold">Sold</option>
			</select>
		</div>
	{/if}

	{#if !user}
		<div class="rounded-lg border border-yellow-200 bg-yellow-50 p-8 text-center">
			<p class="text-sm text-yellow-800">Sign in to see your tracked listings.</p>
		</div>
	{:else if loading}
		<div class="py-12 text-center">
			<div class="mx-auto h-8 w-8 animate-spin rounded-full border-4 border-gray-300 border-t-blue-500"></div>
		</div>
	{:else if error}
		<div class="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{error}</div>
	{:else if filtered().length === 0}
		<div class="rounded-lg border border-gray-200 bg-white p-12 text-center shadow-sm">
			<p class="text-gray-500">
				{items.length === 0
					? 'No tracked listings yet. Browse a design and click "Track Listing" on any BoatTrader result.'
					: 'No listings match this filter.'}
			</p>
		</div>
	{:else}
		<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
			{#each filtered() as item}
				<div class="rounded-lg border border-gray-200 bg-white p-5 shadow-sm">
					<div class="flex items-start justify-between">
						<div>
							<div class="font-semibold text-gray-900">
								{item.year ?? ''} {item.make} {item.model}
							</div>
							<div class="mt-1 text-sm text-gray-600">
								{[item.last_location_city, item.last_location_state].filter(Boolean).join(', ')}
							</div>
						</div>
						<div class="flex flex-col items-end gap-2">
							{#if item.last_asking_price}
								<div class="text-lg font-bold text-blue-600">
									{formatCurrency(item.last_asking_price)}
								</div>
							{/if}
							<span class="rounded px-2 py-0.5 text-xs font-medium {statusBadge(item.status)}">
								{statusLabel(item.status)}
							</span>
						</div>
					</div>
					{#if item.last_checked_at}
						<div class="mt-2 text-xs text-gray-400">
							Last checked: {new Date(item.last_checked_at).toLocaleDateString()}
						</div>
					{/if}
					<div class="mt-3 flex items-center gap-3">
						<a
							href="https://www.boattrader.com/boat/{item.boattrader_id}/"
							target="_blank"
							rel="noopener noreferrer"
							class="text-xs text-blue-600 hover:text-blue-800"
						>
							View on BoatTrader
						</a>
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
	{/if}
</div>
