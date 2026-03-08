<script lang="ts">
	import { goto } from '$app/navigation';
	import { supabase } from '$lib/supabase';
	import { onMount } from 'svelte';

	let message = $state('Completing sign in...');

	onMount(async () => {
		const { error } = await supabase.auth.getSession();
		if (error) {
			message = `Error: ${error.message}`;
		} else {
			goto('/');
		}
	});
</script>

<div class="py-20 text-center">
	<p class="text-gray-600">{message}</p>
</div>
