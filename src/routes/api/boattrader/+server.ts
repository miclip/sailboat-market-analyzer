import { json } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import type { RequestHandler } from './$types';

// BoatTrader relocated this endpoint off api-gateway.boats.com (which now 404s)
// and onto their main origin, which sits behind a WAF. The key still works, but
// the WAF rejects server-side callers regardless of headers, so in practice this
// returns 403 until we have a licensed feed. Kept pointing at the real current
// address so the only thing that has to change is how we're allowed to reach it.
const API_BASE = 'https://www.boattrader.com/app/search/boat';
const API_KEY = env.BOATTRADER_API_KEY ?? '';
const TIMEOUT_MS = 15_000;

const UNAVAILABLE = 'Live BoatTrader listings are temporarily unavailable.';

/** Upstream is unreachable — distinct from a search that legitimately found nothing. */
function unavailable(reason: string) {
	return json({ error: UNAVAILABLE, unavailable: true, reason }, { status: 503 });
}

export const GET: RequestHandler = async ({ url }) => {
	const make = url.searchParams.get('make');
	const model = url.searchParams.get('model');
	const id = url.searchParams.get('id');
	const page = url.searchParams.get('page') ?? '1';
	const pageSize = url.searchParams.get('pageSize') ?? '20';

	if (!API_KEY) {
		return unavailable('not_configured');
	}

	const params = new URLSearchParams({
		apikey: API_KEY,
		country: 'US',
		page,
		pageSize,
		sort: 'modified-desc',
		fields:
			'id,make,model,year,price,location,specifications,portalLink,propulsion,hullMaterial,fuelType,description,media,dateCreated'
	});

	if (id) {
		params.set('id', id);
	} else if (make) {
		params.set('make', make);
		if (model) {
			params.set('model', model);
		}
	} else {
		return json({ error: 'make or id required' }, { status: 400 });
	}

	let res: Response;
	try {
		res = await fetch(`${API_BASE}?${params}`, {
			headers: { Accept: 'application/json' },
			signal: AbortSignal.timeout(TIMEOUT_MS)
		});
	} catch (e) {
		const reason = e instanceof Error && e.name === 'TimeoutError' ? 'timeout' : 'network';
		console.error(`[boattrader] ${reason} reaching upstream`);
		return unavailable(reason);
	}

	if (!res.ok) {
		// Don't forward the upstream body — a WAF block is a full HTML page.
		console.error(`[boattrader] upstream returned ${res.status}`);
		return unavailable(`upstream_${res.status}`);
	}

	// A challenge page can come back 200 with HTML; don't feed that to the parser.
	if (!(res.headers.get('content-type') ?? '').includes('application/json')) {
		console.error('[boattrader] upstream returned non-JSON body');
		return unavailable('non_json');
	}

	try {
		return json(await res.json());
	} catch {
		console.error('[boattrader] could not parse upstream JSON');
		return unavailable('parse');
	}
};
