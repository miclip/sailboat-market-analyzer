<script lang="ts">
	interface Props {
		prompt: string;
	}

	let { prompt }: Props = $props();

	let copied = $state(false);

	async function copyToClipboard() {
		await navigator.clipboard.writeText(prompt);
		copied = true;
		setTimeout(() => (copied = false), 2000);
	}

	function downloadAsText() {
		const blob = new Blob([prompt], { type: 'text/plain' });
		const url = URL.createObjectURL(blob);
		const a = document.createElement('a');
		a.href = url;
		a.download = 'boat-analysis-prompt.txt';
		a.click();
		URL.revokeObjectURL(url);
	}
</script>

<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
	<div class="mb-4 flex items-center justify-between">
		<h3 class="text-lg font-semibold text-gray-900">Claude Analysis Prompt</h3>
		<div class="flex gap-2">
			<button
				onclick={copyToClipboard}
				class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
			>
				{copied ? 'Copied!' : 'Copy'}
			</button>
			<button
				onclick={downloadAsText}
				class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors"
			>
				Download
			</button>
		</div>
	</div>

	<pre class="max-h-96 overflow-y-auto rounded-lg bg-gray-50 p-4 text-sm text-gray-800 whitespace-pre-wrap">{prompt}</pre>
</div>
