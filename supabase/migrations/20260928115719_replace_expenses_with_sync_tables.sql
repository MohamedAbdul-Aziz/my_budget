-- The first cloud schema did not match the app (bigint ids, a title column, no
-- categories) and never held data. Replaced by tables that mirror the app's
-- local SQLite tables, one copy per user.
drop function if exists public.get_total_expenses();
drop function if exists public.add_expense(text, numeric);
drop table if exists public.expenses;

-- Timestamps are milliseconds since the epoch, exactly as the app stores them,
-- so values round-trip without conversion. updated_at comes from the device
-- that made the change and decides which copy wins (newest wins).
create table public.categories (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  name text not null,
  icon_name text not null,
  color_value bigint not null,
  is_default boolean not null default false,
  sort_order integer not null default 0,
  updated_at bigint not null,
  deleted_at bigint,
  -- Built-in categories have the same id on every phone, so ids are only
  -- unique per user.
  primary key (user_id, id)
);

create table public.expenses (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  amount double precision not null,
  description text,
  category_id text not null,
  date bigint not null,
  month_key text not null,
  created_at bigint not null,
  updated_at bigint not null,
  deleted_at bigint,
  primary key (user_id, id)
);

create table public.user_settings (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  key text not null,
  value text not null,
  updated_at bigint not null,
  primary key (user_id, key)
);

-- Newest wins, enforced here rather than trusted to each phone: an upsert that
-- carries an older (or equal) updated_at than the stored row is skipped.
create or replace function public.keep_newest_row()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.updated_at <= old.updated_at then
    return null;
  end if;
  return new;
end;
$$;

create trigger categories_keep_newest
  before update on public.categories
  for each row execute function public.keep_newest_row();

create trigger expenses_keep_newest
  before update on public.expenses
  for each row execute function public.keep_newest_row();

create trigger user_settings_keep_newest
  before update on public.user_settings
  for each row execute function public.keep_newest_row();

alter table public.categories enable row level security;
alter table public.expenses enable row level security;
alter table public.user_settings enable row level security;

-- Each signed-in user reads and writes only their own rows. Rows are never
-- hard-deleted by the app (deletes sync as deleted_at), so there is no
-- delete policy.
create policy categories_select_own on public.categories
  for select to authenticated using ((select auth.uid()) = user_id);
create policy categories_insert_own on public.categories
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy categories_update_own on public.categories
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy expenses_select_own on public.expenses
  for select to authenticated using ((select auth.uid()) = user_id);
create policy expenses_insert_own on public.expenses
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy expenses_update_own on public.expenses
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy user_settings_select_own on public.user_settings
  for select to authenticated using ((select auth.uid()) = user_id);
create policy user_settings_insert_own on public.user_settings
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy user_settings_update_own on public.user_settings
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
