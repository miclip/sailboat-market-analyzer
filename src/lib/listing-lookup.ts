import { parseRecord, type BoatTraderListing } from './boattrader';

const LISTING_URL_PATTERN = /^https?:\/\/www\.(yachtworld|boattrader)\.com\//;
const LISTING_ID_PATTERN = /(\d+)\/?(?:\?.*)?$/;

/**
 * Check if a URL is from yachtworld.com or boattrader.com.
 */
export function isBoatListingUrl(url: string): boolean {
	return LISTING_URL_PATTERN.test(url);
}

/**
 * Extract the numeric listing ID from a YachtWorld or BoatTrader URL.
 *
 * Supports patterns like:
 *   https://www.yachtworld.com/yacht/2001-amel-super-maramu-2000-10065291/
 *   https://www.boattrader.com/boat/2001-amel-super-maramu-2000-10065291/
 *   URLs with or without trailing slash, with or without query params.
 */
export function extractListingId(url: string): number | null {
	if (!isBoatListingUrl(url)) {
		return null;
	}

	// Strip any hash fragment before matching
	const urlWithoutHash = url.split('#')[0];
	const match = urlWithoutHash.match(LISTING_ID_PATTERN);

	if (!match) {
		return null;
	}

	const id = Number(match[1]);
	return Number.isFinite(id) ? id : null;
}

/**
 * Fetch a single listing from the BoatTrader API by its numeric ID.
 * Returns null if the listing is not found.
 */
export async function fetchListingById(id: number): Promise<BoatTraderListing | null> {
	const res = await fetch(`/api/boattrader?id=${id}`);

	if (!res.ok) {
		throw new Error(`BoatTrader API error: ${res.status}`);
	}

	const data = await res.json();
	const records = data.search?.records ?? [];

	if (records.length === 0) {
		return null;
	}

	return parseRecord(records[0]);
}
