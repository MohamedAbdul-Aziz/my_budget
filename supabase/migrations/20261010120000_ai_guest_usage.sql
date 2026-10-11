-- Daily question count for guests of the AI assistant: people who use it
-- without an account (supabase/functions/ai-assistant). Signed-in users are
-- still counted per account in ai_usage.
--
-- A key is either `device:<id>`, a random id the app keeps on the phone, or
-- `ip:<hash>`, a salted SHA-256 of the caller's IP address (the address
-- itself is never stored). Only the counts are kept: never a question, a
-- summary or an answer.
--
-- Quota behaviour, as in ai_usage: a day is a UTC calendar day, and a
-- question counts as soon as the server accepts it. Rows older than a week
-- are cleared as new ones come in, so the table stays small.

create table if not exists public.ai_guest_usage (
  key text not null check (length(key) <= 80),
  day date not null,
  count integer not null default 0 check (count >= 0),
  primary key (key, day)
);

create index if not exists ai_guest_usage_day on public.ai_guest_usage (day);

-- Row level security with no policies, and no grants: only the Edge
-- Function, through the security definer function below, touches the
-- table.
alter table public.ai_guest_usage enable row level security;
revoke all on table public.ai_guest_usage from public, anon, authenticated;

-- Counts one question for p_key today and says whether it is allowed.
-- Atomic, like bump_ai_usage: the insert-or-increment is one statement that
-- stops at p_limit. Callable by the service role only.
create or replace function public.bump_ai_guest_usage(
  p_key text,
  p_limit integer
)
returns boolean
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  today date := (now() at time zone 'utc')::date;
  allowed boolean;
begin
  with bumped as (
    insert into public.ai_guest_usage as u (key, day, count)
    select p_key, today, 1
    where p_limit > 0
    on conflict (key, day) do update
      set count = u.count + 1
      where u.count < p_limit
    returning u.count
  )
  select exists (select 1 from bumped) into allowed;

  delete from public.ai_guest_usage where day < today - 7;

  return allowed;
end;
$$;

revoke execute on function public.bump_ai_guest_usage(text, integer)
  from public, anon, authenticated;
grant execute on function public.bump_ai_guest_usage(text, integer)
  to service_role;
