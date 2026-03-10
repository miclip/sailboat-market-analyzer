import { json } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import type { RequestHandler } from './$types';
import { getSupabaseAdmin } from '$lib/supabase-server';
import { computeSnapshotStats } from '$lib/snapshot-utils';
import { parseRecord } from '$lib/boattrader';
import { boats } from '$lib/seed-data';

export const config = { maxDuration: 300 };

const API_BASE = 'https://api-gateway.boats.com/api-boattrader-client/app/search/boat';
const FIELDS =
	'id,make,model,year,price,location,specifications,portalLink,propulsion,hullMaterial,fuelType,description,media,dateCreated';
const DESIGNS_PER_RUN = 10;

function sleep(ms: number): Promise<void> {
	return new Promise((r) => setTimeout(r, ms));
}

function shuffle<T>(arr: T[]): T[] {
	const a = [...arr];
	for (let i = a.length - 1; i > 0; i--) {
		const j = Math.floor(Math.random() * (i + 1));
		[a[i], a[j]] = [a[j], a[i]];
	}
	return a;
}

export const GET: RequestHandler = async ({ request }) => {
	// Verify Vercel cron secret
	const authHeader = request.headers.get('authorization');
	const cronSecret = env.CRON_SECRET;
	if (cronSecret && authHeader !== `Bearer ${cronSecret}`) {
		return json({
			error: 'Unauthorized',
			debug: {
				hasAuthHeader: !!authHeader,
				authHeaderPrefix: authHeader?.substring(0, 10),
				hasCronSecret: !!cronSecret,
				cronSecretLength: cronSecret?.length,
				match: authHeader === `Bearer ${cronSecret}`
			}
		}, { status: 401 });
	}

	const apiKey = env.BOATTRADER_API_KEY;
	if (!apiKey) {
		return json({ error: 'BOATTRADER_API_KEY not configured' }, { status: 500 });
	}

	const supabase = getSupabaseAdmin();
	const selected = shuffle(boats).slice(0, DESIGNS_PER_RUN);
	const results: Array<{ design: string; count: number; error?: string }> = [];
	const today = new Date().toISOString().split('T')[0];

	for (const boat of selected) {
		try {
			// Derive model name by removing manufacturer prefix
			const model = boat.design_name
				.replace(new RegExp('^' + boat.manufacturer + '\\s*', 'i'), '')
				.trim();

			const params = new URLSearchParams({
				apikey: apiKey,
				country: 'US',
				make: boat.manufacturer,
				page: '1',
				pageSize: '50',
				sort: 'modified-desc',
				fields: FIELDS
			});
			if (model) params.set('model', model);

			const res = await fetch(`${API_BASE}?${params}`, {
				headers: { Accept: 'application/json' }
			});

			if (!res.ok) {
				results.push({ design: boat.id, count: 0, error: `HTTP ${res.status}` });
			} else {
				const data = await res.json();
				const records = data.search?.records ?? [];
				const listings = records.map(parseRecord);
				const stats = computeSnapshotStats(listings);

				await supabase.from('market_snapshots').upsert(
					{
						boat_design_id: boat.id,
						snapshot_date: today,
						...stats
					},
					{ onConflict: 'boat_design_id,snapshot_date' }
				);

				results.push({ design: boat.id, count: stats.listing_count });
			}
		} catch (e) {
			results.push({
				design: boat.id,
				count: 0,
				error: e instanceof Error ? e.message : 'Unknown error'
			});
		}

		// Random delay 3-10 seconds between requests
		if (selected.indexOf(boat) < selected.length - 1) {
			await sleep(3000 + Math.random() * 7000);
		}
	}

	return json({ processed: results.length, results });
};
