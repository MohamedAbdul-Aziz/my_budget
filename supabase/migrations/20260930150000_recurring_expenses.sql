-- Recurring payments (app schema version 4): rent, bills and subscriptions,
-- each with a schedule and whether it is logged automatically or confirmed
-- by the user. A payment it logs is an ordinary row in `expenses`.
--
-- Mirrors the phone's `recurring_expenses` table column for column, plus
-- `user_id`. Due dates are calendar days: the app sends and reads them as
-- `yyyy-MM-dd`, which is how PostgREST represents a `date`. Without this
-- table, backups from phones on the new version fail.
create table if not exists public.recurring_expenses (
  user_id uuid not null references auth.users (id) on delete cascade,
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

alter table public.recurring_expenses enable row level security;

drop policy if exists "Own recurring payments: read" on public.recurring_expenses;
create policy "Own recurring payments: read"
  on public.recurring_expenses for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Own recurring payments: add" on public.recurring_expenses;
create policy "Own recurring payments: add"
  on public.recurring_expenses for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Own recurring payments: change" on public.recurring_expenses;
create policy "Own recurring payments: change"
  on public.recurring_expenses for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "Own recurring payments: remove" on public.recurring_expenses;
create policy "Own recurring payments: remove"
  on public.recurring_expenses for delete
  to authenticated
  using ((select auth.uid()) = user_id);

-- Newest wins, as for every other synced table: an upsert carrying an older
-- or equal `updated_at` leaves the stored row alone, whichever phone sends
-- it. Returning null from a BEFORE UPDATE trigger skips that row's update.
create or replace function public.recurring_expenses_keep_newest()
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

drop trigger if exists recurring_expenses_keep_newest on public.recurring_expenses;
create trigger recurring_expenses_keep_newest
  before update on public.recurring_expenses
  for each row execute function public.recurring_expenses_keep_newest();
