export type RudderType = 'skeg_hung' | 'spade' | 'full_keel_integrated' | 'transom_hung';
export type KeelType = 'full' | 'fin' | 'modified_fin' | 'bulb_fin' | 'wing' | 'centerboard';
export type MastStep = 'keel_stepped' | 'deck_stepped';
export type RigType = 'sloop' | 'cutter' | 'ketch' | 'cutter_ketch' | 'yawl' | 'schooner';
export type CockpitType = 'center' | 'aft';
export type HullType = 'full_keel' | 'fin_keel' | 'modified_full' | 'twin_keel';
export type ForefootDepth = 'deep' | 'moderate' | 'cut_away';
export type GalleyLayout = 'u_shaped' | 'l_shaped' | 'corridor' | 'open_linear';
export type SternType = 'canoe' | 'transom' | 'sugar_scoop' | 'reverse_transom';

export type ConditionTier = 'offshore_ready' | 'good' | 'fair' | 'project';
export type SailsCondition = 'new' | 'good' | 'fair' | 'worn';
export type ListingStatus = 'active' | 'sold' | 'relisted' | 'withdrawn' | 'unknown';
export type LocationMarket =
	| 'puget_sound'
	| 'san_francisco_bay'
	| 'socal'
	| 'gulf_coast'
	| 'east_coast_ne'
	| 'east_coast_se'
	| 'great_lakes'
	| 'international';
export type ReporterRole = 'buyer' | 'seller' | 'broker' | 'observer';

export interface Boat {
	id: string;
	design_name: string;
	manufacturer: string;
	year_range_start?: number;
	year_range_end?: number;
	length_ft?: number;
	beam_ft?: number;
	displacement_lbs?: number;
	ballast_lbs?: number;
	ballast_ratio?: number;
	lwl_ft?: number;
	sail_area_sqft?: number;
	sa_displacement_ratio?: number;

	rudder_type?: RudderType;
	keel_type?: KeelType;
	mast_step?: MastStep;
	rig_type?: RigType;
	cockpit_type?: CockpitType;
	hull_type?: HullType;
	galley_layout?: GalleyLayout;
	stern_type?: SternType;

	underbody_pct?: number;
	forefoot_depth?: ForefootDepth;

	motion_comfort_ratio?: number;
	capsize_screening_value?: number;
	displacement_length_ratio?: number;

	cabins?: number;
	berths?: number;
	sea_berths?: number;

	has_backstay?: boolean;
	has_teak_decks?: boolean;
	self_steering_compatible?: boolean;
	watermaker_standard?: boolean;
	generator_standard?: boolean;

	notes?: string;
	source_url?: string;
}

export interface BoatScores {
	boat_id: string;
	score_coastal_cruising: number;
	score_bluewater: number;
	score_pacific_ready: number;
	score_singlehand: number;
	score_liveaboard: number;
	score_upwind: number;
	score_downwind: number;
	score_breakdown?: Record<string, ScoreBreakdownItem[]>;
}

export interface ScoreBreakdownItem {
	factor: string;
	weight: number;
	value: string;
	points: number;
}

export interface Listing {
	id: string;
	boat_id: string;
	yachtworld_url?: string;
	boattrader_url?: string;
	listing_url?: string;
	asking_price?: number;
	list_date?: string;
	delist_date?: string;
	days_on_market?: number;
	year_built?: number;
	location_city?: string;
	location_state?: string;
	location_market?: LocationMarket;
	engine_make?: string;
	engine_model?: string;
	engine_hp?: number;
	engine_hours?: number;
	engine_year?: number;
	hull_material?: string;
	condition_tier?: ConditionTier;
	rigging_age_years?: number;
	sails_condition?: SailsCondition;
	electronics_age_years?: number;
	recent_refit?: boolean;
	refit_notes?: string;
	broker_name?: string;
	description?: string;
	status: ListingStatus;
}

export interface Comp {
	id: string;
	listing_id: string;
	reported_sale_price?: number;
	sale_date?: string;
	reporter_role?: ReporterRole;
	notes?: string;
	verified: boolean;
	confidence_score: number;
	flagged: boolean;
}

export type ScoreDimension =
	| 'coastal_cruising'
	| 'bluewater'
	| 'pacific_ready'
	| 'singlehand'
	| 'liveaboard'
	| 'upwind'
	| 'downwind';

export interface PromptListingSummary {
	url: string;
	year?: number;
	asking_price?: number;
	location?: string;
	engine_hours?: number;
	engine_info?: string;
	hull_material?: string;
	condition?: string;
	rigging_age_years?: number;
	sails_condition?: string;
	electronics_age_years?: number;
	recent_refit?: boolean;
	refit_notes?: string;
	description?: string;
	days_on_market?: number;
}

export interface PromptInputs {
	boat: Boat;
	scores: BoatScores;
	listing?: Listing;
	activeListings?: PromptListingSummary[];
	comps?: Comp[];
	use_case_primary: string;
	experience_level: string;
	target_waters: string;
}

export interface ExplorationSession {
	id: string;
	user_id: string;
	name: string;
	use_case?: string;
	experience?: string;
	waters?: string;
	preferences: UserPreferences;
	current_step: number;
	created_at: string;
	updated_at: string;
}

export type WatchlistStatus = 'active' | 'sold' | 'delisted' | 'price_changed' | 'unknown';

export interface WatchlistItem {
	id: string;
	user_id: string;
	boattrader_id: number;
	boat_design_id?: string;
	session_id?: string;
	make: string;
	model: string;
	year?: number;
	last_asking_price?: number;
	last_location_city?: string;
	last_location_state?: string;
	last_checked_at?: string;
	status: WatchlistStatus;
	listing_url?: string;
	notes?: string;
	created_at: string;
}

export interface UserPreferences {
	id?: string;
	user_id?: string;
	cockpit_type?: CockpitType | null;
	no_teak_decks: boolean;
	no_canoe_stern: boolean;
	rig_preference?: RigType | null;
	min_loa_ft?: number | null;
	max_loa_ft?: number | null;
	galley_preference?: GalleyLayout | null;
	prefer_keel_stepped: boolean;
	max_budget?: number | null;
	updated_at?: string;
}

export const defaultPreferences: UserPreferences = {
	no_teak_decks: false,
	no_canoe_stern: false,
	prefer_keel_stepped: false
};

export type PriceSnapshotStatus = 'active' | 'not_found';

export interface PriceSnapshot {
	id: string;
	watchlist_id: string;
	asking_price?: number;
	status?: PriceSnapshotStatus;
	snapshot_at: string;
}
