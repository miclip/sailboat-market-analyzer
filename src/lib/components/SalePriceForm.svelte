<script lang="ts">
	import { supabase } from '$lib/supabase';
	import { getUser } from '$lib/auth';
	import type { ReporterRole } from '$lib/types';

	interface Props {
		listingId: string;
	}

	let { listingId }: Props = $props();

	const user = $derived(getUser());

	let reportedSalePrice = $state<number | undefined>();
	let saleDate = $state('');
	let reporterRole = $state<ReporterRole | ''>('');
	let notes = $state('');
	let submitting = $state(false);
	let submitError = $state('');
	let submitSuccess = $state(false);

	const roles: { value: ReporterRole; label: string }[] = [
		{ value: 'buyer', label: 'Buyer' },
		{ value: 'seller', label: 'Seller' },
		{ value: 'broker', label: 'Broker' },
		{ value: 'observer', label: 'Observer' }
	];

	async function handleSubmit(e: Event) {
		e.preventDefault();
		if (!user || !reportedSalePrice) return;

		submitting = true;
		submitError = '';

		const { error } = await supabase.from('comps').insert({
			listing_id: listingId,
			reported_sale_price: reportedSalePrice,
			sale_date: saleDate || null,
			reporter_role: reporterRole || null,
			notes: notes || null,
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
	<p class="text-sm text-gray-500">Sign in to report a sale price.</p>
{:else if submitSuccess}
	<div class="rounded-lg border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-700">
		Sale price reported. Thank you!
	</div>
{:else}
	<form onsubmit={handleSubmit} class="space-y-4">
		<div class="grid gap-4 sm:grid-cols-2">
			<div>
				<label for="sale-price" class="mb-1 block text-sm font-medium text-gray-700">Sale Price ($) *</label>
				<input
					id="sale-price"
					type="number"
					bind:value={reportedSalePrice}
					required
					placeholder="165000"
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				/>
			</div>
			<div>
				<label for="sale-date" class="mb-1 block text-sm font-medium text-gray-700">Sale Date</label>
				<input
					id="sale-date"
					type="date"
					bind:value={saleDate}
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				/>
			</div>
		</div>
		<div class="grid gap-4 sm:grid-cols-2">
			<div>
				<label for="role" class="mb-1 block text-sm font-medium text-gray-700">Your Role</label>
				<select
					id="role"
					bind:value={reporterRole}
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				>
					<option value="">Select...</option>
					{#each roles as r}
						<option value={r.value}>{r.label}</option>
					{/each}
				</select>
			</div>
			<div>
				<label for="comp-notes" class="mb-1 block text-sm font-medium text-gray-700">Notes</label>
				<input
					id="comp-notes"
					type="text"
					bind:value={notes}
					placeholder="Any details..."
					class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
				/>
			</div>
		</div>

		{#if submitError}
			<div class="text-sm text-red-600">{submitError}</div>
		{/if}

		<button
			type="submit"
			disabled={submitting}
			class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50 transition-colors"
		>
			{submitting ? 'Submitting...' : 'Report Sale Price'}
		</button>
	</form>
{/if}
