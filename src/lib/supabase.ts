import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import { browser } from '$app/environment';

let _client: SupabaseClient | null = null;

export function getSupabase(): SupabaseClient {
	if (!_client) {
		// Dynamically import env to avoid SSR issues
		const url = browser ? (import.meta.env.PUBLIC_SUPABASE_URL ?? '') : '';
		const key = browser ? (import.meta.env.PUBLIC_SUPABASE_ANON_KEY ?? '') : '';
		_client = createClient(url, key);
	}
	return _client;
}

// Convenience export — all Supabase calls should be in client-side code (onMount, handlers)
export const supabase = new Proxy({} as SupabaseClient, {
	get(_target, prop) {
		return (getSupabase() as unknown as Record<string | symbol, unknown>)[prop];
	}
});
