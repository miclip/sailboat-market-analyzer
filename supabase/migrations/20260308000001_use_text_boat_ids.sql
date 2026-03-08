-- Change boats.id from uuid to text for readable slug-based IDs.
-- This must run after the initial schema migration.
-- If the initial migration failed and tables don't exist yet, this is a no-op.

-- Drop dependent foreign keys first
alter table boat_scores drop constraint if exists boat_scores_boat_id_fkey;
alter table listings drop constraint if exists listings_boat_id_fkey;

-- Change boats.id to text
alter table boats alter column id drop default;
alter table boats alter column id type text using id::text;

-- Change referencing columns to text
alter table boat_scores alter column boat_id type text using boat_id::text;
alter table listings alter column boat_id type text using boat_id::text;

-- Re-add foreign keys
alter table boat_scores add constraint boat_scores_boat_id_fkey
  foreign key (boat_id) references boats(id) on delete cascade;
alter table listings add constraint listings_boat_id_fkey
  foreign key (boat_id) references boats(id);
