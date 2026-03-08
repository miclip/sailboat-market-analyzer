export interface BoatTraderListing {
	id: number;
	make: string;
	model: string;
	year: number;
	priceUSD: number | null;
	priceHidden: boolean;
	city: string;
	state: string;
	country: string;
	lengthFt: number | null;
	beamFt: number | null;
	displacementLbs: number | null;
	draftFt: number | null;
	cabins: number | null;
	heads: number | null;
	url: string;
}

interface BTRecord {
	id: number;
	make: string;
	model: string;
	year: number;
	portalLink?: string;
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

export function parseRecord(r: BTRecord): BoatTraderListing {
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
		url: r.portalLink ?? `https://www.boattrader.com/boat/${r.id}/`
	};
}

export async function searchListings(
	make: string,
	model?: string,
	page = 1,
	pageSize = 20
): Promise<{ listings: BoatTraderListing[]; total: number }> {
	const params = new URLSearchParams({
		make,
		page: String(page),
		pageSize: String(pageSize)
	});

	if (model) {
		params.set('model', model);
	}

	const res = await fetch(`/api/boattrader?${params}`);

	if (!res.ok) {
		throw new Error(`BoatTrader search failed: ${res.status}`);
	}

	const data = await res.json();
	const records: BTRecord[] = data.search?.records ?? [];
	let listings = records.map(parseRecord);

	// API does fuzzy model matching — filter to exact model match
	if (model) {
		const m = model.toLowerCase();
		listings = listings.filter((l) => l.model.toLowerCase() === m);
	}

	return {
		listings,
		total: listings.length
	};
}
