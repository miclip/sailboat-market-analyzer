import type { BoatTraderListing } from './boattrader';

export interface SnapshotStats {
	listing_count: number;
	min_price: number | null;
	max_price: number | null;
	median_price: number | null;
	avg_days_on_market: number | null;
	listing_ids: number[];
}

export function computeSnapshotStats(listings: BoatTraderListing[]): SnapshotStats {
	const listing_ids = listings.map((l) => l.id);
	const listing_count = listings.length;

	// Filter to listings with visible prices
	const prices = listings
		.filter((l) => l.priceUSD != null && !l.priceHidden)
		.map((l) => l.priceUSD!)
		.sort((a, b) => a - b);

	let min_price: number | null = null;
	let max_price: number | null = null;
	let median_price: number | null = null;

	if (prices.length > 0) {
		min_price = prices[0];
		max_price = prices[prices.length - 1];
		const mid = Math.floor(prices.length / 2);
		median_price =
			prices.length % 2 === 0
				? Math.round((prices[mid - 1] + prices[mid]) / 2)
				: prices[mid];
	}

	// Compute average days on market from listDate
	const now = Date.now();
	const daysOnMarket = listings
		.filter((l) => l.listDate)
		.map((l) => Math.max(0, Math.floor((now - new Date(l.listDate!).getTime()) / 86400000)));

	const avg_days_on_market =
		daysOnMarket.length > 0
			? Math.round(daysOnMarket.reduce((a, b) => a + b, 0) / daysOnMarket.length)
			: null;

	return { listing_count, min_price, max_price, median_price, avg_days_on_market, listing_ids };
}
