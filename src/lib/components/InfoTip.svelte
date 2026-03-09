<script lang="ts">
	interface Props {
		text: string;
	}

	let { text }: Props = $props();
	let show = $state(false);
</script>

<span class="relative inline-block">
	<button
		class="ml-1 inline-flex h-4 w-4 items-center justify-center rounded-full bg-gray-200 text-[10px] font-bold text-gray-500 hover:bg-gray-300 hover:text-gray-700 transition-colors"
		onmouseenter={() => (show = true)}
		onmouseleave={() => (show = false)}
		onclick={(e) => { e.preventDefault(); e.stopPropagation(); show = !show; }}
		aria-label="More info"
		type="button"
	>
		?
	</button>
	{#if show}
		<div
			class="absolute bottom-full left-1/2 z-50 mb-2 w-56 -translate-x-1/2 rounded-lg bg-gray-900 px-3 py-2 text-xs font-normal leading-relaxed text-white shadow-lg"
			role="tooltip"
		>
			{text}
			<div class="absolute left-1/2 top-full -translate-x-1/2 border-4 border-transparent border-t-gray-900"></div>
		</div>
	{/if}
</span>
