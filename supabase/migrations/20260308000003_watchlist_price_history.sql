-- Watchlist and price history tables

create table watchlist (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  boattrader_id int not null,
  boat_design_id text references boats(id),
  make text not null,
  model text not null,
  year int,
  last_asking_price int,
  last_location_city text,
  last_location_state text,
  last_checked_at timestamptz,
  status text check (status in ('active', 'sold', 'delisted', 'price_changed', 'unknown')) default 'active',
  notes text,
  created_at timestamptz default now(),
  unique (user_id, boattrader_id)
);

create table price_history (
  id uuid primary key default gen_random_uuid(),
  watchlist_id uuid references watchlist(id) on delete cascade,
  asking_price int,
  status text check (status in ('active', 'not_found')),
  snapshot_at timestamptz default now()
);

-- Indexes
create index idx_watchlist_user_id on watchlist(user_id);
create index idx_price_history_watchlist_id on price_history(watchlist_id);

-- RLS
alter table watchlist enable row level security;
alter table price_history enable row level security;

-- Watchlist policies
create policy "Users can view their own watchlist items"
  on watchlist for select
  using (auth.uid() = user_id);

create policy "Users can insert their own watchlist items"
  on watchlist for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own watchlist items"
  on watchlist for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete their own watchlist items"
  on watchlist for delete
  using (auth.uid() = user_id);

-- Price history policies (join through watchlist to check ownership)
create policy "Users can view their own price history"
  on price_history for select
  using (exists (
    select 1 from watchlist where watchlist.id = price_history.watchlist_id and watchlist.user_id = auth.uid()
  ));

create policy "Users can insert price history for their own watchlist items"
  on price_history for insert
  with check (exists (
    select 1 from watchlist where watchlist.id = price_history.watchlist_id and watchlist.user_id = auth.uid()
  ));

create policy "Users can update their own price history"
  on price_history for update
  using (exists (
    select 1 from watchlist where watchlist.id = price_history.watchlist_id and watchlist.user_id = auth.uid()
  ))
  with check (exists (
    select 1 from watchlist where watchlist.id = price_history.watchlist_id and watchlist.user_id = auth.uid()
  ));

create policy "Users can delete their own price history"
  on price_history for delete
  using (exists (
    select 1 from watchlist where watchlist.id = price_history.watchlist_id and watchlist.user_id = auth.uid()
  ));
