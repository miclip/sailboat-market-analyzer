<script lang="ts">
	import type { Boat } from '$lib/types';

	interface Props {
		boats: Boat[];
		onselect: (boat: Boat) => void;
	}

	let { boats, onselect }: Props = $props();

	let query = $state('');
	let showDropdown = $state(false);

	const filtered = $derived(
		query.length < 2
			? []
			: boats
					.filter((b) => {
						const q = query.toLowerCase();
						return (
							b.design_name.toLowerCase().includes(q) ||
							b.manufacturer.toLowerCase().includes(q)
						);
					})
					.slice(0, 10)
	);

	function handleSelect(boat: Boat) {
		query = boat.design_name;
		showDropdown = false;
		onselect(boat);
	}

	function handleInput() {
		showDropdown = query.length >= 2;
	}

	function handleBlur() {
		setTimeout(() => (showDropdown = false), 200);
	}
</script>

<div class="relative">
	<input
		type="text"
		bind:value={query}
		oninput={handleInput}
		onfocus={() => query.length >= 2 && (showDropdown = true)}
		onblur={handleBlur}
		placeholder="Search by design name or manufacturer..."
		class="w-full rounded-lg border border-gray-300 px-4 py-3 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500 focus:outline-none"
	/>

	{#if showDropdown && filtered.length > 0}
		<ul
			class="absolute z-10 mt-1 max-h-64 w-full overflow-y-auto rounded-lg border border-gray-200 bg-white shadow-lg"
		>
			{#each filtered as boat}
				<li>
					<button
						class="w-full px-4 py-3 text-left hover:bg-blue-50"
						onmousedown={() => handleSelect(boat)}
					>
						<span class="font-medium text-gray-900">{boat.design_name}</span>
						<span class="ml-2 text-sm text-gray-500">
							{boat.manufacturer} &middot; {boat.year_range_start ?? '?'}–{boat.year_range_end ?? '?'}
							{#if boat.length_ft}&middot; {boat.length_ft}ft{/if}
						</span>
					</button>
				</li>
			{/each}
		</ul>
	{:else if showDropdown && query.length >= 2 && filtered.length === 0}
		<div
			class="absolute z-10 mt-1 w-full rounded-lg border border-gray-200 bg-white px-4 py-3 text-sm text-gray-500 shadow-lg"
		>
			No designs found matching "{query}"
		</div>
	{/if}
</div>
