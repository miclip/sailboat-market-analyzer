-- Core boat design specs (curated, admin-managed)
create table boats (
  id uuid primary key default gen_random_uuid(),
  design_name text not null,
  manufacturer text not null,
  year_range_start int,
  year_range_end int,
  length_ft numeric,
  beam_ft numeric,
  displacement_lbs int,
  ballast_lbs int,
  ballast_ratio numeric,
  lwl_ft numeric,
  sail_area_sqft int,
  sa_displacement_ratio numeric,

  rudder_type text check (rudder_type in (
    'skeg_hung', 'spade', 'full_keel_integrated', 'transom_hung'
  )),
  keel_type text check (keel_type in (
    'full', 'fin', 'modified_fin', 'bulb_fin', 'wing', 'centerboard'
  )),
  mast_step text check (mast_step in ('keel_stepped', 'deck_stepped')),
  rig_type text check (rig_type in (
    'sloop', 'cutter', 'ketch', 'yawl', 'schooner'
  )),
  cockpit_type text check (cockpit_type in ('center', 'aft')),
  hull_type text check (hull_type in (
    'full_keel', 'fin_keel', 'modified_full', 'twin_keel'
  )),

  underbody_pct numeric,
  forefoot_depth text check (forefoot_depth in ('deep', 'moderate', 'cut_away')),

  motion_comfort_ratio numeric,
  capsize_screening_value numeric,
  displacement_length_ratio numeric,

  self_steering_compatible bool,
  watermaker_standard bool,
  generator_standard bool,

  notes text,
  source_url text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Use-case scores (computed + stored, refreshable)
create table boat_scores (
  id uuid primary key default gen_random_uuid(),
  boat_id uuid references boats(id) on delete cascade,

  score_coastal_cruising int,
  score_bluewater int,
  score_pacific_ready int,
  score_singlehand int,
  score_liveaboard int,
  score_upwind int,
  score_downwind int,

  score_breakdown jsonb,

  computed_at timestamptz default now()
);

-- Community-submitted listings
create table listings (
  id uuid primary key default gen_random_uuid(),
  boat_id uuid references boats(id),

  yachtworld_url text unique,
  asking_price int,
  list_date date,
  delist_date date,
  days_on_market int generated always as (
    extract(day from delist_date - list_date)::int
  ) stored,

  location_city text,
  location_state text,
  location_market text check (location_market in (
    'puget_sound', 'san_francisco_bay', 'socal', 'gulf_coast',
    'east_coast_ne', 'east_coast_se', 'great_lakes', 'international'
  )),

  engine_hours int,
  condition_tier text check (condition_tier in (
    'offshore_ready', 'good', 'fair', 'project'
  )),
  rigging_age_years int,
  sails_condition text check (sails_condition in (
    'new', 'good', 'fair', 'worn'
  )),
  recent_refit bool,
  refit_notes text,

  status text check (status in (
    'active', 'sold', 'relisted', 'withdrawn', 'unknown'
  )) default 'active',

  submitted_by uuid references auth.users(id),
  created_at timestamptz default now()
);

-- Self-reported sale prices
create table comps (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid references listings(id) on delete cascade,

  reported_sale_price int,
  sale_date date,
  reporter_role text check (reporter_role in (
    'buyer', 'seller', 'broker', 'observer'
  )),
  notes text,

  verified bool default false,
  confidence_score int default 50,
  flagged bool default false,

  submitted_by uuid references auth.users(id),
  submitted_at timestamptz default now()
);

-- Row Level Security
alter table boats enable row level security;
alter table boat_scores enable row level security;
alter table listings enable row level security;
alter table comps enable row level security;

-- Boats and scores: public read, admin write
create policy "public read boats" on boats for select using (true);
create policy "public read scores" on boat_scores for select using (true);

-- Listings: public read, authenticated write
create policy "public read listings" on listings for select using (true);
create policy "auth insert listings" on listings for insert
  with check (auth.uid() = submitted_by);

-- Comps: public read, authenticated write
create policy "public read comps" on comps for select using (true);
create policy "auth insert comps" on comps for insert
  with check (auth.uid() = submitted_by);

-- Indexes
create index idx_boats_manufacturer on boats(manufacturer);
create index idx_boats_design_name on boats(design_name);
create index idx_boat_scores_boat_id on boat_scores(boat_id);
create index idx_listings_boat_id on listings(boat_id);
create index idx_listings_status on listings(status);
create index idx_comps_listing_id on comps(listing_id);
