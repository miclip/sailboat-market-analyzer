-- Repair: add no_canoe_stern if table was created before the column existed
alter table user_preferences add column if not exists no_canoe_stern boolean default false;
