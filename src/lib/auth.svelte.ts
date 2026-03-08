import { supabase } from './supabase';
import type { User } from '@supabase/supabase-js';

let currentUser = $state<User | null>(null);

export function getUser(): User | null {
	return currentUser;
}

export function setUser(user: User | null) {
	currentUser = user;
}

export async function initAuth() {
	const {
		data: { session }
	} = await supabase.auth.getSession();
	currentUser = session?.user ?? null;

	supabase.auth.onAuthStateChange((_event, session) => {
		currentUser = session?.user ?? null;
	});
}

export async function signInWithEmail(email: string): Promise<{ error: string | null }> {
	const { error } = await supabase.auth.signInWithOtp({
		email,
		options: { emailRedirectTo: window.location.origin }
	});
	return { error: error?.message ?? null };
}

export async function signOut() {
	await supabase.auth.signOut();
}
