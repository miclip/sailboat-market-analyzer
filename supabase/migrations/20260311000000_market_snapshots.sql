-- Market snapshots: daily aggregates of BoatTrader listings per design
create table market_snapshots (
  id uuid primary key default gen_random_uuid(),
  boat_design_id text not null,
  snapshot_date date not null default current_date,
  listing_count int not null default 0,
  min_price int,
  max_price int,
  median_price int,
  avg_days_on_market int,
  listing_ids jsonb not null default '[]'::jsonb,
  created_at timestamptz default now(),
  unique (boat_design_id, snapshot_date)
);

create index idx_market_snapshots_design_date
  on market_snapshots(boat_design_id, snapshot_date desc);

alter table market_snapshots enable row level security;

-- Anyone can read market data
create policy "public read market_snapshots"
  on market_snapshots for select using (true);
