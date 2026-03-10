import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { getSupabaseAdmin } from '$lib/supabase-server';
import { computeSnapshotStats } from '$lib/snapshot-utils';
import { boats } from '$lib/seed-data';
import type { BoatTraderListing } from '$lib/boattrader';

export const POST: RequestHandler = async ({ request }) => {
	const body = await request.json();
	const { boat_design_id, listings } = body as {
		boat_design_id: string;
		listings: BoatTraderListing[];
	};

	if (!boat_design_id || !Array.isArray(listings)) {
		return json({ error: 'boat_design_id and listings required' }, { status: 400 });
	}

	// Validate design exists
	if (!boats.find((b) => b.id === boat_design_id)) {
		return json({ error: 'Unknown design' }, { status: 400 });
	}

	const stats = computeSnapshotStats(listings);
	const supabase = getSupabaseAdmin();

	const { data, error } = await supabase
		.from('market_snapshots')
		.upsert(
			{
				boat_design_id,
				snapshot_date: new Date().toISOString().split('T')[0],
				...stats
			},
			{ onConflict: 'boat_design_id,snapshot_date' }
		)
		.select()
		.single();

	if (error) {
		return json({ error: error.message }, { status: 500 });
	}

	return json(data);
};
