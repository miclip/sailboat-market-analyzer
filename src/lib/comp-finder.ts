import type { Listing, LocationMarket } from './types';

export interface InferredPriceRange {
	low: number;
	high: number;
	confidence: 'low' | 'medium' | 'high';
	method: string;
}

const marketMultiplier: Record<LocationMarket, number> = {
	puget_sound: 0.97,
	san_francisco_bay: 0.96,
	socal: 0.95,
	gulf_coast: 0.92,
	east_coast_ne: 0.94,
	east_coast_se: 0.93,
	great_lakes: 0.91,
	international: 0.90
};

const conditionMultiplier: Record<string, number> = {
	offshore_ready: 1.0,
	good: 0.95,
	fair: 0.87,
	project: 0.75
};

export function inferSalePriceRange(listing: Listing): InferredPriceRange | null {
	if (!listing.asking_price) return null;

	const ask = listing.asking_price;
	const dom = listing.days_on_market;

	let discountLow: number;
	let discountHigh: number;
	let method: string;

	if (listing.status === 'relisted') {
		discountLow = 0.75;
		discountHigh = 0.85;
		method = 'relisted (15-25% below ask)';
	} else if (dom != null && dom < 30) {
		discountLow = 0.95;
		discountHigh = 1.0;
		method = 'fast sale <30 days (0-5% below ask)';
	} else if (dom != null && dom < 90) {
		discountLow = 0.9;
		discountHigh = 0.95;
		method = 'normal sale 30-90 days (5-10% below ask)';
	} else if (dom != null && dom > 90) {
		discountLow = 0.8;
		discountHigh = 0.9;
		method = 'slow sale >90 days (10-20% below ask)';
	} else {
		discountLow = 0.85;
		discountHigh = 0.95;
		method = 'default estimate (5-15% below ask)';
	}

	const mktMult = listing.location_market ? (marketMultiplier[listing.location_market] ?? 0.93) : 0.93;
	const condMult = listing.condition_tier ? (conditionMultiplier[listing.condition_tier] ?? 0.9) : 0.9;

	return {
		low: Math.round(ask * discountLow * mktMult * condMult),
		high: Math.round(ask * discountHigh * mktMult * condMult),
		confidence: dom != null ? 'medium' : 'low',
		method
	};
}

export interface CompScore {
	listing: Listing;
	score: number;
	inferred: InferredPriceRange | null;
}

export function scoreComps(
	target: Listing,
	candidates: Listing[],
	targetYearStart?: number,
	targetYearEnd?: number
): CompScore[] {
	return candidates
		.filter((c) => c.id !== target.id)
		.map((candidate) => {
			let score = 0;

			// Same market (20%)
			if (candidate.location_market && candidate.location_market === target.location_market) {
				score += 20;
			}

			// Same condition tier (25%)
			if (candidate.condition_tier && candidate.condition_tier === target.condition_tier) {
				score += 25;
			}

			// Engine hours within 1000hrs (25%)
			if (candidate.engine_hours != null && target.engine_hours != null) {
				const diff = Math.abs(candidate.engine_hours - target.engine_hours);
				if (diff <= 1000) {
					score += 25 * (1 - diff / 1000);
				}
			}

			// Listing recency — prefer more recent (30%)
			if (candidate.list_date) {
				const listed = new Date(candidate.list_date);
				const now = new Date();
				const monthsAgo = (now.getTime() - listed.getTime()) / (1000 * 60 * 60 * 24 * 30);
				if (monthsAgo <= 36) {
					score += 30 * (1 - monthsAgo / 36);
				}
			}

			return {
				listing: candidate,
				score: Math.round(score),
				inferred: inferSalePriceRange(candidate)
			};
		})
		.filter((c) => c.score > 0)
		.sort((a, b) => b.score - a.score)
		.slice(0, 5);
}
