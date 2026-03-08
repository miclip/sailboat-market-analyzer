import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

const API_BASE = 'https://api-gateway.boats.com/api-boattrader-client/app/search/boat';
const API_KEY = '8b08b9bc353c494a80c60fb86debfc56';

export const GET: RequestHandler = async ({ url }) => {
	const make = url.searchParams.get('make');
	const model = url.searchParams.get('model');
	const id = url.searchParams.get('id');
	const page = url.searchParams.get('page') ?? '1';
	const pageSize = url.searchParams.get('pageSize') ?? '20';

	const params = new URLSearchParams({
		apikey: API_KEY,
		country: 'US',
		page,
		pageSize,
		sort: 'modified-desc',
		fields: 'id,make,model,year,price,location,specifications,portalLink'
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

	const res = await fetch(`${API_BASE}?${params}`, {
		headers: { Accept: 'application/json' }
	});

	if (!res.ok) {
		return json({ error: `Upstream error: ${res.status}` }, { status: res.status });
	}

	const data = await res.json();
	return json(data);
};
