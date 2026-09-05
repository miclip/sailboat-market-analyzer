import { json } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import type { RequestHandler } from './$types';
import { getSupabaseAdmin } from '$lib/supabase-server';
import { computeSnapshotStats } from '$lib/snapshot-utils';
import { parseRecord, type BoatTraderListing } from '$lib/boattrader';
import { boats } from '$lib/seed-data';

export const config = { maxDuration: 300 };

// Moved off api-gateway.boats.com (now 404s) to BoatTrader's main origin, which
// is behind a WAF that rejects server-side callers. See api/boattrader/+server.ts.
const API_BASE = 'https://www.boattrader.com/app/search/boat';
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
		return json({ error: 'Unauthorized' }, { status: 401 });
	}

	const apiKey = env.BOATTRADER_API_KEY;
	if (!apiKey) {
		return json({ error: 'BOATTRADER_API_KEY not configured' }, { status: 500 });
	}

	const supabase = getSupabaseAdmin();
	const selected = shuffle(boats).slice(0, DESIGNS_PER_RUN);
	const results: Array<Record<string, unknown>> = [];
	const today = new Date().toISOString().split('T')[0];
	let unavailable = '';

	for (const boat of selected) {
		try {
			// Derive model name by removing manufacturer prefix and parenthetical suffixes
			const model = boat.design_name
				.replace(new RegExp('^' + boat.manufacturer + '\\s*', 'i'), '')
				.replace(/\s*\(.*\)\s*$/, '')
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
				headers: { Accept: 'application/json' },
				signal: AbortSignal.timeout(20_000)
			});

			if (!res.ok) {
				results.push({ design: boat.id, count: 0, error: `HTTP ${res.status}` });
				// 403/429/5xx is the upstream refusing us as a class, not a per-design
				// miss. Stop the run instead of sleeping between more certain failures.
				if (res.status === 403 || res.status === 429 || res.status >= 500) {
					unavailable = `Upstream returned ${res.status}`;
					break;
				}
			} else if (!(res.headers.get('content-type') ?? '').includes('application/json')) {
				results.push({ design: boat.id, count: 0, error: 'Non-JSON response' });
				unavailable = 'Upstream returned a non-JSON body (WAF challenge?)';
				break;
			} else {
				const data = await res.json();
				const records = data.search?.records ?? [];
				let listings = records.map(parseRecord);

				// Filter out fuzzy matches (e.g. "Maramu" search returning "Super Maramu")
				if (model) {
					const sm = model.toLowerCase();
					listings = listings.filter((l: BoatTraderListing) => {
						const lm = l.model.toLowerCase().trim();
						return lm === sm || new RegExp(`^${sm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}(\\s|\\d|$)`, 'i').test(lm);
					});
				}

				const stats = computeSnapshotStats(listings);

				await supabase.from('market_snapshots').upsert(
					{
						boat_design_id: boat.id,
						snapshot_date: today,
						...stats
					},
					{ onConflict: 'boat_design_id,snapshot_date' }
				);

				results.push({ design: boat.id, ...stats });
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

	if (unavailable) {
		console.error(`[cron/market-snapshot] aborted: ${unavailable}`);
		return json(
			{
				error: 'BoatTrader upstream unavailable — no snapshots written.',
				detail: unavailable,
				processed: results.length,
				attempted: selected.length,
				results
			},
			{ status: 503 }
		);
	}

	return json({ processed: results.length, results });
};
