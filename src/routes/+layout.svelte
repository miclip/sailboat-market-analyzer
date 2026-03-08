<script lang="ts">
	import '../app.css';

	let { children } = $props();
</script>

<div class="min-h-screen bg-gray-50">
	<header class="border-b border-gray-200 bg-white">
		<div class="mx-auto flex max-w-6xl items-center justify-between px-4 py-4">
			<a href="/" class="text-xl font-bold text-gray-900">Bluewater Boat Analyzer</a>
			<nav class="flex gap-6 text-sm font-medium text-gray-600">
				<a href="/" class="hover:text-blue-600">Home</a>
				<a href="/boats" class="hover:text-blue-600">Browse Designs</a>
				<a href="/compare" class="hover:text-blue-600">Compare</a>
			</nav>
		</div>
	</header>

	<main class="mx-auto max-w-6xl px-4 py-8">
		{@render children()}
	</main>

	<footer class="border-t border-gray-200 bg-white py-6 text-center text-sm text-gray-500">
		Bluewater Boat Analyzer &mdash; Evaluating offshore sailing vessels by the design characteristics that matter.
	</footer>
</div>
