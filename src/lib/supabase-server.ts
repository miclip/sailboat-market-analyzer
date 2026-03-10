import { createClient } from '@supabase/supabase-js';
import { env } from '$env/dynamic/private';
import { env as publicEnv } from '$env/dynamic/public';

export function getSupabaseAdmin() {
	return createClient(
		publicEnv.PUBLIC_SUPABASE_URL ?? '',
		env.SUPABASE_SERVICE_ROLE_KEY ?? ''
	);
}
