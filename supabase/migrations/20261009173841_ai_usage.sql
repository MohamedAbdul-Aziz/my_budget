-- Daily question count for the AI assistant (supabase/functions/ai-assistant).
--
-- Only the count is kept: never a question, a summary or an answer. The
-- table is server-only bookkeeping, not user data, so it is not synced to
-- the phone, not in backup files, and outside the app's Data Parity Rule.
--
-- Quota behaviour:
-- * A "day" is a UTC calendar day, so every account's quota resets at
--   00:00 UTC, whatever the phone's timezone.
-- * A question counts as soon as the server accepts it, before the AI
--   provider is called, so a question the provider then fails still counts.
--   That keeps the check a single atomic step and caps what one account can
--   cost us even when the provider is struggling.

create table if not exists public.ai_usage (
  user_id uuid not null references auth.users (id) on delete cascade,
  day date not null,
  count integer not null default 0 check (count >= 0),
  primary key (user_id, day)
);

-- Row level security with no policies: no client role can read or write a
-- row. Only the Edge Function, through the security definer function below,
-- touches the table.
alter table public.ai_usage enable row level security;
revoke all on table public.ai_usage from public, anon, authenticated;

-- Counts one question for p_uid today and says whether it is allowed.
--
-- Atomic: the insert-or-increment is one statement, and the `where` on the
-- update stops it at p_limit, so concurrent requests can never push the
-- count past the limit. When the limit is already reached the update
-- matches nothing, no row comes back, and the result is false.
--
-- p_uid and p_limit come from the Edge Function: the uid from the caller's
-- verified session token, the limit from a server constant. Clients cannot
-- call this function at all (see the grants below), so they can supply
-- neither.
create or replace function public.bump_ai_usage(p_uid uuid, p_limit integer)
returns boolean
language sql
volatile
security definer
set search_path = ''
as $$
  with bumped as (
    insert into public.ai_usage as u (user_id, day, count)
    select p_uid, (now() at time zone 'utc')::date, 1
    where p_limit > 0
    on conflict (user_id, day) do update
      set count = u.count + 1
      where u.count < p_limit
    returning u.count
  )
  select exists (select 1 from bumped);
$$;

revoke execute on function public.bump_ai_usage(uuid, integer)
  from public, anon, authenticated;
grant execute on function public.bump_ai_usage(uuid, integer) to service_role;
