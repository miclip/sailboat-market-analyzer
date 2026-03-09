import { supabase } from './supabase';
import { defaultPreferences } from './types';
import type { ExplorationSession, UserPreferences } from './types';

let sessions = $state<ExplorationSession[]>([]);
let activeSessionId = $state<string | null>(null);

export function getSessions(): ExplorationSession[] {
	return sessions;
}

export function getActiveSession(): ExplorationSession | null {
	return sessions.find((s) => s.id === activeSessionId) ?? null;
}

export function getActiveSessionId(): string | null {
	return activeSessionId;
}

export function setActiveSessionId(id: string | null) {
	activeSessionId = id;
}

export async function loadSessions(userId: string) {
	const { data } = await supabase
		.from('exploration_sessions')
		.select('*')
		.eq('user_id', userId)
		.order('updated_at', { ascending: false });

	sessions = (data ?? []).map((d) => ({
		...d,
		preferences: { ...defaultPreferences, ...(d.preferences as object) }
	})) as ExplorationSession[];
}

export async function createSession(
	userId: string,
	name: string,
	state: { use_case?: string; experience?: string; waters?: string; preferences?: UserPreferences; current_step?: number }
): Promise<ExplorationSession | null> {
	const { data, error } = await supabase
		.from('exploration_sessions')
		.insert({
			user_id: userId,
			name,
			use_case: state.use_case || null,
			experience: state.experience || null,
			waters: state.waters || null,
			preferences: state.preferences ?? defaultPreferences,
			current_step: state.current_step ?? 1
		})
		.select()
		.single();

	if (error || !data) return null;

	const session: ExplorationSession = {
		...data,
		preferences: { ...defaultPreferences, ...(data.preferences as object) }
	} as ExplorationSession;

	sessions = [session, ...sessions];
	activeSessionId = session.id;
	return session;
}

let saveTimer: ReturnType<typeof setTimeout> | null = null;

export function saveSessionDebounced(
	sessionId: string,
	state: { use_case?: string; experience?: string; waters?: string; preferences?: UserPreferences; current_step?: number }
) {
	if (saveTimer) clearTimeout(saveTimer);
	saveTimer = setTimeout(async () => {
		await supabase
			.from('exploration_sessions')
			.update({
				use_case: state.use_case || null,
				experience: state.experience || null,
				waters: state.waters || null,
				preferences: state.preferences ?? defaultPreferences,
				current_step: state.current_step ?? 1,
				updated_at: new Date().toISOString()
			})
			.eq('id', sessionId);

		// Update local copy
		sessions = sessions.map((s) =>
			s.id === sessionId
				? { ...s, ...state, updated_at: new Date().toISOString() }
				: s
		) as ExplorationSession[];
	}, 1000);
}

export async function deleteSession(sessionId: string) {
	await supabase.from('exploration_sessions').delete().eq('id', sessionId);
	sessions = sessions.filter((s) => s.id !== sessionId);
	if (activeSessionId === sessionId) activeSessionId = null;
}

export async function renameSession(sessionId: string, name: string) {
	await supabase
		.from('exploration_sessions')
		.update({ name, updated_at: new Date().toISOString() })
		.eq('id', sessionId);

	sessions = sessions.map((s) =>
		s.id === sessionId ? { ...s, name } : s
	);
}
