<script lang="ts">
	import '../app.css';
	import { onMount } from 'svelte';
	import { initAuth } from '$lib/auth.svelte';
	import AuthButton from '$lib/components/AuthButton.svelte';

	let { children } = $props();
	let menuOpen = $state(false);

	onMount(() => {
		initAuth();
	});
</script>

<div class="min-h-screen bg-gray-50">
	<header class="border-b border-gray-200 bg-white">
		<div class="mx-auto flex max-w-6xl items-center justify-between px-4 py-4">
			<a href="/" class="text-xl font-bold text-gray-900">Sailboat Market Analyzer</a>

			<!-- Desktop nav -->
			<div class="hidden items-center gap-6 md:flex">
				<nav class="flex gap-6 text-sm font-medium text-gray-600">
					<a href="/" class="hover:text-blue-600">Home</a>
					<a href="/boats" class="hover:text-blue-600">Designs</a>
					<a href="/listings" class="hover:text-blue-600">Listings</a>
					<a href="/compare" class="hover:text-blue-600">Compare</a>
					<a href="/guide" class="hover:text-blue-600">Guide</a>
				</nav>
				<AuthButton />
			</div>

			<!-- Mobile hamburger -->
			<button
				onclick={() => (menuOpen = !menuOpen)}
				class="flex h-10 w-10 items-center justify-center rounded-lg text-gray-600 hover:bg-gray-100 md:hidden"
				aria-label="Toggle menu"
			>
				{#if menuOpen}
					<svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
						<path d="M6 18L18 6M6 6l12 12" />
					</svg>
				{:else}
					<svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
						<path d="M4 6h16M4 12h16M4 18h16" />
					</svg>
				{/if}
			</button>
		</div>

		<!-- Mobile menu -->
		{#if menuOpen}
			<div class="border-t border-gray-100 px-4 py-3 md:hidden">
				<nav class="flex flex-col gap-3 text-sm font-medium text-gray-600">
					<a href="/" onclick={() => (menuOpen = false)} class="rounded-lg px-3 py-2 hover:bg-gray-50 hover:text-blue-600">Home</a>
					<a href="/boats" onclick={() => (menuOpen = false)} class="rounded-lg px-3 py-2 hover:bg-gray-50 hover:text-blue-600">Designs</a>
					<a href="/listings" onclick={() => (menuOpen = false)} class="rounded-lg px-3 py-2 hover:bg-gray-50 hover:text-blue-600">Listings</a>
					<a href="/compare" onclick={() => (menuOpen = false)} class="rounded-lg px-3 py-2 hover:bg-gray-50 hover:text-blue-600">Compare</a>
					<a href="/guide" onclick={() => (menuOpen = false)} class="rounded-lg px-3 py-2 hover:bg-gray-50 hover:text-blue-600">Guide</a>
				</nav>
				<div class="mt-3 border-t border-gray-100 pt-3">
					<AuthButton />
				</div>
			</div>
		{/if}
	</header>

	<main class="mx-auto max-w-6xl px-4 py-6 sm:py-8">
		{@render children()}
	</main>

	<footer class="border-t border-gray-200 bg-white py-6 text-center text-sm text-gray-500">
		Sailboat Market Analyzer &mdash; Find the right boat for how you sail.
	</footer>
</div>
