<script lang="ts">
	import { getUser, signInWithEmail, signOut } from '$lib/auth.svelte';

	let email = $state('');
	let showForm = $state(false);
	let sending = $state(false);
	let sent = $state(false);
	let error = $state('');

	const user = $derived(getUser());

	async function handleSubmit(e: Event) {
		e.preventDefault();
		sending = true;
		error = '';
		const result = await signInWithEmail(email);
		sending = false;
		if (result.error) {
			error = result.error;
		} else {
			sent = true;
			setTimeout(() => {
				sent = false;
				showForm = false;
				email = '';
			}, 6000);
		}
	}

	async function handleSignOut() {
		await signOut();
		showForm = false;
		sent = false;
	}
</script>

{#if user}
	<div class="flex items-center gap-3">
		<span class="text-sm text-gray-500">{user.email}</span>
		<button
			onclick={handleSignOut}
			class="rounded-lg border border-gray-300 px-3 py-1.5 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
		>
			Sign out
		</button>
	</div>
{:else if sent}
	<div class="text-sm text-green-600">
		Check your email for the magic link — also check junk/spam.
		<span class="text-xs text-gray-400 ml-1">From: noreply@mail.app.supabase.io</span>
	</div>
{:else if showForm}
	<form onsubmit={handleSubmit} class="flex items-center gap-2">
		<input
			type="email"
			bind:value={email}
			placeholder="you@example.com"
			required
			class="rounded-lg border border-gray-300 px-3 py-1.5 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500 focus:outline-none"
		/>
		<button
			type="submit"
			disabled={sending}
			class="rounded-lg bg-blue-600 px-3 py-1.5 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50 transition-colors"
		>
			{sending ? 'Sending...' : 'Send link'}
		</button>
		{#if error}
			<span class="text-sm text-red-600">{error}</span>
		{/if}
	</form>
{:else}
	<button
		onclick={() => (showForm = true)}
		class="rounded-lg bg-blue-600 px-3 py-1.5 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
	>
		Sign in
	</button>
{/if}
