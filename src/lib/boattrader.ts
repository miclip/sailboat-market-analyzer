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
	// New fields
	engineMake: string | null;
	engineModel: string | null;
	engineHp: number | null;
	engineHours: number | null;
	engineCount: number | null;
	fuelType: string | null;
	hullMaterial: string | null;
	description: string | null;
	listDate: string | null;
	thumbnailUrl: string | null;
}

interface BTRecord {
	id: number;
	make: string;
	model: string;
	year: number;
	portalLink?: string;
	dateCreated?: string;
	description?: string;
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
	propulsion?: {
		engines?: Array<{
			make?: string;
			model?: string;
			hp?: number;
			hours?: number;
			fuelType?: string;
		}>;
	};
	hullMaterial?: string;
	fuelType?: string;
	media?: {
		images?: Array<{
			url?: string;
		}>;
	};
}

export function parseRecord(r: BTRecord): BoatTraderListing {
	const dims = r.specifications?.dimensions;
	const lengthFt = dims?.lengths?.overall?.ft ?? dims?.lengths?.nominal?.ft ?? null;
	const engine = r.propulsion?.engines?.[0];

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
		url: r.portalLink ?? `https://www.boattrader.com/boat/${r.id}/`,
		engineMake: engine?.make ?? null,
		engineModel: engine?.model ?? null,
		engineHp: engine?.hp ?? null,
		engineHours: engine?.hours ?? null,
		engineCount: r.propulsion?.engines?.length ?? null,
		fuelType: engine?.fuelType ?? r.fuelType ?? null,
		hullMaterial: r.hullMaterial ?? null,
		description: r.description ?? null,
		listDate: r.dateCreated ?? null,
		thumbnailUrl: r.media?.images?.[0]?.url ?? null
	};
}

/**
 * Check if a listing's model matches the searched model.
 * BoatTrader does fuzzy matching, so "Maramu" returns "Super Maramu" too.
 * We require the listing model to start with the search model (word boundary).
 */
function modelMatches(listingModel: string, searchModel: string): boolean {
	const lm = listingModel.toLowerCase().trim();
	const sm = searchModel.toLowerCase().trim();
	if (!sm) return true;
	if (lm === sm) return true;
	// Listing model starts with search model followed by a space, digit, or end
	return new RegExp(`^${sm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}(\\s|\\d|$)`, 'i').test(lm);
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

	if (model) {
		listings = listings.filter((l) => modelMatches(l.model, model));
	}

	return {
		listings,
		total: listings.length
	};
}
