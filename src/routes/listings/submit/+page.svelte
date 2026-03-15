<script lang="ts">
	import ListingForm from '$lib/components/ListingForm.svelte';
</script>

<svelte:head>
	<title>Submit a Listing | Sailboat Market Analyzer</title>
	<meta name="description" content="Submit a sailboat listing from YachtWorld to help build community market data and comp pricing." />
	<meta property="og:title" content="Submit a Listing — Sailboat Market Analyzer" />
	<meta property="og:description" content="Submit a sailboat listing to help build community market data." />
	<meta property="og:type" content="website" />
</svelte:head>

<div class="mx-auto max-w-2xl space-y-6">
	<div>
		<a href="/listings" class="mb-4 inline-block text-sm text-blue-600 hover:text-blue-800">
			&larr; All Listings
		</a>
		<h1 class="text-2xl font-bold text-gray-900">Submit a Listing</h1>
		<p class="mt-1 text-sm text-gray-500">
			Share a YachtWorld listing to help build community comp data.
		</p>
	</div>

	<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
		<ListingForm />
	</div>
</div>
