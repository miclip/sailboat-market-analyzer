import type { BoatTraderListing } from './boattrader';

const API_BASE = 'https://api-gateway.boats.com/api-boattrader-client/app/search/boat';
const API_KEY = '8b08b9bc353c494a80c60fb86debfc56';

const LISTING_URL_PATTERN = /^https?:\/\/www\.(yachtworld|boattrader)\.com\//;
const LISTING_ID_PATTERN = /(\d+)\/?(?:\?.*)?$/;

interface BTRecord {
	id: number;
	make: string;
	model: string;
	year: number;
	price?: {
		hidden: boolean;
		type?: {
			amount?: {
				USD?: number;
			};
		};
	};
	location?: {
		address?: {
			city?: string;
			state?: string;
			country?: string;
		};
	};
	specifications?: {
		dimensions?: {
			lengths?: {
				nominal?: { ft?: number };
				overall?: { ft?: number };
			};
			beam?: { ft?: number };
			maxDraft?: { ft?: number };
		};
		weights?: {
			displacement?: { lb?: number };
		};
		accommodation?: {
			cabins?: number;
			heads?: number;
		};
	};
}

function parseRecord(r: BTRecord): BoatTraderListing {
	const dims = r.specifications?.dimensions;
	const lengthFt = dims?.lengths?.overall?.ft ?? dims?.lengths?.nominal?.ft ?? null;

	return {
		id: r.id,
		make: r.make,
		model: r.model,
		year: r.year,
		priceUSD: r.price?.type?.amount?.USD ?? null,
		priceHidden: r.price?.hidden ?? true,
		city: r.location?.address?.city ?? '',
		state: r.location?.address?.state ?? '',
		country: r.location?.address?.country ?? '',
		lengthFt,
		beamFt: dims?.beam?.ft ?? null,
		displacementLbs: r.specifications?.weights?.displacement?.lb ?? null,
		draftFt: dims?.maxDraft?.ft ?? null,
		cabins: r.specifications?.accommodation?.cabins ?? null,
		heads: r.specifications?.accommodation?.heads ?? null,
		url: `https://www.boattrader.com/boat/${r.year}-${r.make}-${r.model}-${r.id}/`.toLowerCase().replace(/\s+/g, '-')
	};
}

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
	const params = new URLSearchParams({
		apikey: API_KEY,
		id: String(id),
		fields: [
			'id', 'make', 'model', 'year',
			'price', 'location', 'specifications'
		].join(',')
	});

	const res = await fetch(`${API_BASE}?${params}`, {
		headers: {
			Accept: 'application/json'
		}
	});

	if (!res.ok) {
		throw new Error(`BoatTrader API error: ${res.status}`);
	}

	const data = await res.json();
	const records: BTRecord[] = data.search?.records ?? [];

	if (records.length === 0) {
		return null;
	}

	return parseRecord(records[0]);
}
