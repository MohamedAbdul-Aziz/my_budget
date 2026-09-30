-- People and debts (app schema version 5): the people the user shares costs
-- with, the money that changed hands with each, every settle-up, and each
-- transaction's change log.
--
-- Each table mirrors the phone's table of the same name column for column,
-- plus `user_id`. Without these tables, backups from phones on the new
-- version fail. Rows reference each other by id only, as the other synced
-- tables do: the phone uploads parents first and checks references itself.
create table if not exists public.people (
  user_id uuid not null references auth.users (id) on delete cascade,
  id text not null,
  name text not null,
  phone text,
  color_value bigint not null,
  created_at bigint not null,
  updated_at bigint not null,
  deleted_at bigint,
  primary key (user_id, id)
);

-- `net_amount` is the balance the settlement cleared: positive when the
-- person paid the user back, negative when the user paid them.
create table if not exists public.settlements (
  user_id uuid not null references auth.users (id) on delete cascade,
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

-- Open until `settled_at` is set, along with the settlement that cleared it.
create table if not exists public.person_transactions (
  user_id uuid not null references auth.users (id) on delete cascade,
  id text not null,
  person_id text not null,
  amount double precision not null check (amount > 0),
  type text not null
    check (type in ('i_paid_for_them', 'they_paid_for_me')),
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
create table if not exists public.person_transaction_edits (
  user_id uuid not null references auth.users (id) on delete cascade,
  id text not null,
  transaction_id text not null,
  amount double precision not null check (amount > 0),
  type text not null
    check (type in ('i_paid_for_them', 'they_paid_for_me')),
  note text,
  date bigint not null,
  edited_at bigint not null,
  updated_at bigint not null,
  deleted_at bigint,
  primary key (user_id, id)
);

-- Newest wins, as for every other synced table: an upsert carrying an older
-- or equal `updated_at` leaves the stored row alone, whichever phone sends
-- it. Returning null from a BEFORE UPDATE trigger skips that row's update.
create or replace function public.people_keep_newest()
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

-- Row level security and the newest-wins trigger, the same on each table:
-- a signed-in user reads and writes only their own rows.
do $$
declare
  t text;
begin
  foreach t in array array[
    'people',
    'settlements',
    'person_transactions',
    'person_transaction_edits'
  ] loop
    execute format('alter table public.%I enable row level security', t);

    execute format('drop policy if exists "Own rows: read" on public.%I', t);
    execute format(
      'create policy "Own rows: read" on public.%I for select '
      'to authenticated using ((select auth.uid()) = user_id)',
      t
    );

    execute format('drop policy if exists "Own rows: add" on public.%I', t);
    execute format(
      'create policy "Own rows: add" on public.%I for insert '
      'to authenticated with check ((select auth.uid()) = user_id)',
      t
    );

    execute format('drop policy if exists "Own rows: change" on public.%I', t);
    execute format(
      'create policy "Own rows: change" on public.%I for update '
      'to authenticated using ((select auth.uid()) = user_id) '
      'with check ((select auth.uid()) = user_id)',
      t
    );

    execute format('drop policy if exists "Own rows: remove" on public.%I', t);
    execute format(
      'create policy "Own rows: remove" on public.%I for delete '
      'to authenticated using ((select auth.uid()) = user_id)',
      t
    );

    execute format('drop trigger if exists %I on public.%I', t || '_keep_newest', t);
    execute format(
      'create trigger %I before update on public.%I '
      'for each row execute function public.people_keep_newest()',
      t || '_keep_newest',
      t
    );
  end loop;
end;
$$;
