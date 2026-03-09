create table if not exists user_preferences (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null unique,
  cockpit_type text,           -- 'center', 'aft', or null (no preference)
  no_teak_decks boolean default false,
  no_canoe_stern boolean default false,
  rig_preference text,         -- 'sloop', 'cutter', 'ketch', 'cutter_ketch', or null
  min_loa_ft numeric,
  max_loa_ft numeric,
  galley_preference text,      -- 'u_shaped', 'l_shaped', 'corridor', 'open_linear', or null
  prefer_keel_stepped boolean default false,
  max_budget numeric,
  updated_at timestamptz default now()
);

-- RLS
alter table user_preferences enable row level security;

create policy "Users can read own preferences"
  on user_preferences for select
  using (auth.uid() = user_id);

create policy "Users can insert own preferences"
  on user_preferences for insert
  with check (auth.uid() = user_id);

create policy "Users can update own preferences"
  on user_preferences for update
  using (auth.uid() = user_id);
