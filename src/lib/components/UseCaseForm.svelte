<script lang="ts">
	interface Props {
		onsubmit: (useCase: string, experience: string, waters: string) => void;
	}

	let { onsubmit }: Props = $props();

	let useCase = $state('');
	let experience = $state('');
	let waters = $state('');

	const useCases = [
		{ value: 'bluewater', label: 'Bluewater Passage-Making', desc: 'Ocean crossings, trade wind routes' },
		{ value: 'pacific', label: 'Pacific Circuit', desc: 'Mexico, South Pacific, NZ/Australia' },
		{ value: 'coastal', label: 'Coastal Cruising', desc: 'Day sails, weekend trips, island hopping' },
		{ value: 'liveaboard', label: 'Liveaboard Cruiser', desc: 'Full-time living aboard, comfort is key' },
		{ value: 'singlehand', label: 'Singlehanded Sailing', desc: 'Solo sailing, manageable sail plan' },
		{ value: 'circumnavigation', label: 'Circumnavigation', desc: 'Around the world, all conditions' }
	];

	const experiences = [
		{ value: 'beginner', label: 'Beginner', desc: 'New to sailing or limited offshore' },
		{ value: 'intermediate', label: 'Intermediate', desc: 'Comfortable coastal, some offshore' },
		{ value: 'experienced', label: 'Experienced', desc: 'Multiple offshore passages' },
		{ value: 'professional', label: 'Professional', desc: 'Delivery captain or equivalent' }
	];

	const waterOptions = [
		'Pacific Ocean',
		'Atlantic Ocean',
		'Caribbean',
		'Mediterranean',
		'Pacific Northwest',
		'New England Coast',
		'Gulf Coast',
		'Great Lakes',
		'Around the World'
	];

	function handleSubmit() {
		if (useCase && experience && waters) {
			onsubmit(useCase, experience, waters);
		}
	}
</script>

<div class="space-y-8">
	<div>
		<h2 class="mb-4 text-lg font-semibold text-gray-900">What's your primary use case?</h2>
		<div class="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
			{#each useCases as uc}
				<button
					onclick={() => (useCase = uc.value)}
					class="rounded-lg border-2 p-4 text-left transition-all
						{useCase === uc.value
						? 'border-blue-500 bg-blue-50'
						: 'border-gray-200 hover:border-gray-300'}"
				>
					<div class="font-medium text-gray-900">{uc.label}</div>
					<div class="mt-1 text-sm text-gray-500">{uc.desc}</div>
				</button>
			{/each}
		</div>
	</div>

	{#if useCase}
		<div>
			<h2 class="mb-4 text-lg font-semibold text-gray-900">What's your experience level?</h2>
			<div class="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
				{#each experiences as exp}
					<button
						onclick={() => (experience = exp.value)}
						class="rounded-lg border-2 p-4 text-left transition-all
							{experience === exp.value
							? 'border-blue-500 bg-blue-50'
							: 'border-gray-200 hover:border-gray-300'}"
					>
						<div class="font-medium text-gray-900">{exp.label}</div>
						<div class="mt-1 text-sm text-gray-500">{exp.desc}</div>
					</button>
				{/each}
			</div>
		</div>
	{/if}

	{#if experience}
		<div>
			<h2 class="mb-4 text-lg font-semibold text-gray-900">Target waters?</h2>
			<div class="flex flex-wrap gap-2">
				{#each waterOptions as w}
					<button
						onclick={() => (waters = w)}
						class="rounded-full px-4 py-2 text-sm font-medium transition-all
							{waters === w
							? 'bg-blue-600 text-white'
							: 'bg-gray-100 text-gray-700 hover:bg-gray-200'}"
					>
						{w}
					</button>
				{/each}
			</div>
		</div>
	{/if}

	{#if useCase && experience && waters}
		<div class="pt-2">
			<button
				onclick={handleSubmit}
				class="rounded-lg bg-blue-600 px-6 py-3 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
			>
				Show Me Designs
			</button>
		</div>
	{/if}
</div>
