-- Brings the cloud copy up to every feature the app syncs (app schema
-- version 5): income categories, recurring payments, and people and debts.
-- Every synced table now mirrors the phone's SQLite table of the same name
-- (listed in lib/core/database/synced_tables.dart) column for column, plus
-- `user_id`. The phone's `dirty` flag never leaves the phone.
--
-- Rules every table follows:
-- * Timestamps are milliseconds since the epoch, exactly as the app stores
--   them. `updated_at` comes from the phone that made the change.
-- * Newest wins: an upsert carrying an older or equal `updated_at` than the
--   stored row is skipped, whichever phone sends it.
-- * A signed-in user reads and writes only their own rows. The app never
--   deletes a row: a delete arrives as `deleted_at`, so there is no delete
--   grant. Deleting the account (the delete-account Edge Function) removes
--   every row through `on delete cascade`.
-- * Rows point at each other by id only. The phone uploads parents first and
--   checks references itself, since several phones send rows in any order.
-- * Checks mirror the app's own validation of a backup file and are never
--   stricter: a row the phone holds but the cloud refuses would block every
--   later backup.
--
-- A table for a new feature: create it with `user_id default auth.uid()
-- references auth.users on delete cascade`, its columns, `updated_at` and
-- `deleted_at`, primary key (user_id, id), then
-- `select private.make_synced('public.<table>');`.

create schema if not exists private;

-- Helpers live outside the API schema, so no client can call them.
create or replace function private.keep_newest_row()
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

-- Row level security, own-row policies, exactly the grants a signed-in user
-- needs (read, and upsert), and the newest-wins trigger.
create or replace function private.make_synced(target regclass)
returns void
language plpgsql
set search_path = ''
as $$
declare
  t text := (select relname from pg_catalog.pg_class where oid = target);
begin
  execute format('alter table %s enable row level security', target);
  execute format('revoke all on %s from anon, authenticated', target);
  execute format('grant select, insert, update on %s to authenticated', target);

  execute format('drop policy if exists %I on %s', t || '_select_own', target);
  execute format(
    'create policy %I on %s for select to authenticated '
    'using ((select auth.uid()) = user_id)',
    t || '_select_own',
    target
  );
  execute format('drop policy if exists %I on %s', t || '_insert_own', target);
  execute format(
    'create policy %I on %s for insert to authenticated '
    'with check ((select auth.uid()) = user_id)',
    t || '_insert_own',
    target
  );
  execute format('drop policy if exists %I on %s', t || '_update_own', target);
  execute format(
    'create policy %I on %s for update to authenticated '
    'using ((select auth.uid()) = user_id) '
    'with check ((select auth.uid()) = user_id)',
    t || '_update_own',
    target
  );

  execute format('drop trigger if exists %I on %s', t || '_keep_newest', target);
  execute format(
    'create trigger %I before update on %s for each row '
    'execute function private.keep_newest_row()',
    t || '_keep_newest',
    target
  );
end;
$$;

revoke all on function private.keep_newest_row() from public;
revoke all on function private.make_synced(regclass) from public;

-- Categories are spending or income, and a transaction is whichever its
-- category is. Rows uploaded before income existed are spending.
alter table public.categories
  add column type text not null default 'expense'
  constraint categories_type_check check (type in ('expense', 'income'));

-- The same limits the app puts on a transaction.
alter table public.expenses
  add constraint expenses_amount_check check (amount > 0),
  add constraint expenses_month_key_check check (month_key ~ '^\d{4}-\d{2}$');

-- Named like the phone's table, as every other synced table is. A removed
-- value is stored as an empty one, so there is no `deleted_at`.
alter table public.user_settings rename to settings;
alter table public.settings rename constraint user_settings_pkey to settings_pkey;
alter table public.settings
  rename constraint user_settings_user_id_fkey to settings_user_id_fkey;
drop policy user_settings_select_own on public.settings;
drop policy user_settings_insert_own on public.settings;
drop policy user_settings_update_own on public.settings;
drop trigger user_settings_keep_newest on public.settings;

-- Rent, bills and subscriptions. Due dates are calendar days: the app sends
-- and reads them as `yyyy-MM-dd`, which is how PostgREST represents a `date`.
-- A payment it logs is an ordinary row in `expenses`.
create table public.recurring_expenses (
  user_id uuid not null default auth.uid()
    references auth.users (id) on delete cascade,
  id text not null,
  title text not null,
  amount double precision not null check (amount > 0),
  category_id text not null,
  frequency text not null default 'monthly'
    check (frequency in ('weekly', 'monthly', 'yearly')),
  due_day integer not null check (due_day between 1 and 31),
  due_month integer check (due_month between 1 and 12),
  mode text not null default 'reminder' check (mode in ('auto', 'reminder')),
  starts_on date not null,
  paid_through date,
  created_at bigint not null,
  updated_at bigint not null,
  deleted_at bigint,
  primary key (user_id, id)
);

-- The people the user shares costs with.
create table public.people (
  user_id uuid not null default auth.uid()
    references auth.users (id) on delete cascade,
  id text not null,
  name text not null,
  phone text,
  color_value bigint not null,
  created_at bigint not null,
  updated_at bigint not null,
  deleted_at bigint,
  primary key (user_id, id)
);

-- Each settle-up. `net_amount` is the balance it cleared: positive when the
-- person paid the user back, negative when the user paid them.
create table public.settlements (
  user_id uuid not null default auth.uid()
    references auth.users (id) on delete cascade,
  id text not null,
  person_id text not null,
  net_amount double precision not null,
  settled_at bigint not null,
  expense_id text,
  created_at bigint not null,
  updated_at bigint not null,
  deleted_at bigint,
  primary key (user_id, id)
);

-- Money that changed hands with a person. Open until `settled_at` is set,
-- along with the settlement that cleared it.
create table public.person_transactions (
  user_id uuid not null default auth.uid()
    references auth.users (id) on delete cascade,
  id text not null,
  person_id text not null,
  amount double precision not null check (amount > 0),
  type text not null check (type in ('i_paid_for_them', 'they_paid_for_me')),
  note text,
  date bigint not null,
  settled_at bigint,
  settlement_id text,
  created_at bigint not null,
  updated_at bigint not null,
  deleted_at bigint,
  primary key (user_id, id)
);

-- The values a transaction had just before each edit.
create table public.person_transaction_edits (
  user_id uuid not null default auth.uid()
    references auth.users (id) on delete cascade,
  id text not null,
  transaction_id text not null,
  amount double precision not null check (amount > 0),
  type text not null check (type in ('i_paid_for_them', 'they_paid_for_me')),
  note text,
  date bigint not null,
  edited_at bigint not null,
  updated_at bigint not null,
  deleted_at bigint,
  primary key (user_id, id)
);

-- Every synced table, the three existing ones included: their policies and
-- triggers are recreated the same way, on the private trigger function.
select private.make_synced('public.categories');
select private.make_synced('public.expenses');
select private.make_synced('public.settings');
select private.make_synced('public.recurring_expenses');
select private.make_synced('public.people');
select private.make_synced('public.settlements');
select private.make_synced('public.person_transactions');
select private.make_synced('public.person_transaction_edits');

-- Replaced by private.keep_newest_row(), which no client can reach.
drop function public.keep_newest_row();

-- The platform's automatic-RLS event trigger function is not meant to be
-- called through the API. Event triggers still run it.
do $$
begin
  if to_regprocedure('public.rls_auto_enable()') is not null then
    revoke all on function public.rls_auto_enable() from public, anon, authenticated;
  end if;
end;
$$;
