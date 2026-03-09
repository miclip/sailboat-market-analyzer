-- Exploration sessions: named, saved search contexts for multi-year boat buying

create table exploration_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  use_case text,
  experience text,
  waters text,
  preferences jsonb default '{}',
  current_step int default 1 check (current_step between 1 and 4),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index idx_sessions_user_id on exploration_sessions(user_id);

-- Link watchlist items to sessions (nullable — existing items stay unlinked)
alter table watchlist add column session_id uuid references exploration_sessions(id) on delete set null;
alter table watchlist add column if not exists listing_url text;
create index idx_watchlist_session_id on watchlist(session_id);

-- RLS
alter table exploration_sessions enable row level security;

create policy "Users can view their own sessions"
  on exploration_sessions for select
  using (auth.uid() = user_id);

create policy "Users can create their own sessions"
  on exploration_sessions for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own sessions"
  on exploration_sessions for update
  using (auth.uid() = user_id);

create policy "Users can delete their own sessions"
  on exploration_sessions for delete
  using (auth.uid() = user_id);
