<script lang="ts">
	import type { UserPreferences } from '$lib/types';
	import {
		getSessions,
		getActiveSession,
		getActiveSessionId,
		setActiveSessionId,
		createSession,
		deleteSession,
		renameSession,
		loadSessions
	} from '$lib/session.svelte';
	import { getUser } from '$lib/auth.svelte';

	interface Props {
		useCase: string;
		experience: string;
		waters: string;
		preferences: UserPreferences;
		currentStep: number;
		onload: (state: { use_case: string; experience: string; waters: string; preferences: UserPreferences; current_step: number }) => void;
	}

	let { useCase, experience, waters, preferences, currentStep, onload }: Props = $props();

	const user = $derived(getUser());
	const sessions = $derived(getSessions());
	const activeSession = $derived(getActiveSession());
	const activeSessionId = $derived(getActiveSessionId());

	let showDropdown = $state(false);
	let showNewInput = $state(false);
	let newName = $state('');
	let editingId = $state<string | null>(null);
	let editName = $state('');
	let loaded = false;

	$effect(() => {
		if (user && !loaded) {
			loaded = true;
			loadSessions(user.id);
		}
	});

	function defaultSessionName(): string {
		const parts = [];
		if (useCase) parts.push(useCase.charAt(0).toUpperCase() + useCase.slice(1));
		if (waters) parts.push(waters);
		return parts.join(' — ') || 'New Session';
	}

	async function handleCreate() {
		if (!user || !newName.trim()) return;
		await createSession(user.id, newName.trim(), {
			use_case: useCase,
			experience,
			waters,
			preferences,
			current_step: currentStep
		});
		newName = '';
		showNewInput = false;
		showDropdown = false;
	}

	function handleSwitch(sessionId: string) {
		setActiveSessionId(sessionId);
		const session = sessions.find((s) => s.id === sessionId);
		if (session) {
			onload({
				use_case: session.use_case ?? '',
				experience: session.experience ?? '',
				waters: session.waters ?? '',
				preferences: session.preferences,
				current_step: session.current_step
			});
		}
		showDropdown = false;
	}

	async function handleDelete(sessionId: string) {
		await deleteSession(sessionId);
	}

	async function handleRename(sessionId: string) {
		if (!editName.trim()) return;
		await renameSession(sessionId, editName.trim());
		editingId = null;
	}

	function startNew() {
		newName = defaultSessionName();
		showNewInput = true;
	}
</script>

{#if user}
	<div class="relative flex items-center gap-3">
		{#if activeSession}
			<div class="flex items-center gap-2 rounded-lg bg-blue-50 px-3 py-1.5">
				<span class="text-xs font-medium text-blue-700">{activeSession.name}</span>
				<button
					onclick={() => { showDropdown = !showDropdown; }}
					class="text-xs text-blue-500 hover:text-blue-700"
				>
					Switch
				</button>
			</div>
		{:else if sessions.length > 0}
			<button
				onclick={() => { showDropdown = !showDropdown; }}
				class="rounded-lg border border-gray-200 px-3 py-1.5 text-xs font-medium text-gray-600 hover:bg-gray-50"
			>
				Resume Session
			</button>
		{/if}

		{#if !activeSession && sessions.length === 0}
			{#if showNewInput}
				<form onsubmit={(e) => { e.preventDefault(); handleCreate(); }} class="flex items-center gap-2">
					<input
						type="text"
						bind:value={newName}
						placeholder="Session name..."
						class="rounded-lg border border-gray-300 px-3 py-1.5 text-xs focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
					/>
					<button type="submit" class="rounded-lg bg-blue-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-blue-700">Save</button>
					<button type="button" onclick={() => { showNewInput = false; }} class="text-xs text-gray-400 hover:text-gray-600">Cancel</button>
				</form>
			{:else}
				<button
					onclick={startNew}
					class="rounded-lg border border-dashed border-gray-300 px-3 py-1.5 text-xs text-gray-500 hover:border-blue-400 hover:text-blue-600"
				>
					Save Session
				</button>
			{/if}
		{:else if !showNewInput}
			<button
				onclick={startNew}
				class="rounded-lg border border-dashed border-gray-300 px-3 py-1.5 text-xs text-gray-500 hover:border-blue-400 hover:text-blue-600"
			>
				New Session
			</button>
		{:else}
			<form onsubmit={(e) => { e.preventDefault(); handleCreate(); }} class="flex items-center gap-2">
				<input
					type="text"
					bind:value={newName}
					placeholder="Session name..."
					class="rounded-lg border border-gray-300 px-3 py-1.5 text-xs focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
				/>
				<button type="submit" class="rounded-lg bg-blue-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-blue-700">Save</button>
				<button type="button" onclick={() => { showNewInput = false; }} class="text-xs text-gray-400 hover:text-gray-600">Cancel</button>
			</form>
		{/if}

		{#if showDropdown}
			<!-- svelte-ignore a11y_click_events_have_key_events -->
			<!-- svelte-ignore a11y_no_static_element_interactions -->
			<div onclick={() => { showDropdown = false; }} class="fixed inset-0 z-10"></div>
			<div class="absolute top-full left-0 z-20 mt-1 w-72 rounded-lg border border-gray-200 bg-white shadow-lg">
				<div class="max-h-64 overflow-y-auto p-2">
					{#each sessions as session}
						<div class="flex items-center justify-between rounded-md px-3 py-2 hover:bg-gray-50 {session.id === activeSessionId ? 'bg-blue-50' : ''}">
							{#if editingId === session.id}
								<form onsubmit={(e) => { e.preventDefault(); handleRename(session.id); }} class="flex flex-1 items-center gap-1">
									<input
										type="text"
										bind:value={editName}
										class="flex-1 rounded border border-gray-300 px-2 py-0.5 text-xs"
									/>
									<button type="submit" class="text-xs text-blue-600">OK</button>
								</form>
							{:else}
								<button
									onclick={() => handleSwitch(session.id)}
									class="flex-1 text-left"
								>
									<div class="text-sm font-medium text-gray-900">{session.name}</div>
									<div class="text-xs text-gray-400">
										{session.use_case ?? 'No use case'} &middot; {session.waters ?? ''}
									</div>
								</button>
								<div class="flex items-center gap-1">
									<button
										onclick={() => { editingId = session.id; editName = session.name; }}
										class="p-1 text-xs text-gray-400 hover:text-gray-600"
										title="Rename"
									>
										&#9998;
									</button>
									<button
										onclick={() => handleDelete(session.id)}
										class="p-1 text-xs text-gray-400 hover:text-red-500"
										title="Delete"
									>
										&times;
									</button>
								</div>
							{/if}
						</div>
					{/each}
				</div>
				<div class="border-t border-gray-100 p-2">
					<button
						onclick={startNew}
						class="w-full rounded-md px-3 py-1.5 text-left text-xs text-blue-600 hover:bg-blue-50"
					>
						+ New Session
					</button>
				</div>
			</div>
		{/if}
	</div>
{/if}
