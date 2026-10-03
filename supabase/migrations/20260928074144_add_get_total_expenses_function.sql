create or replace function public.get_total_expenses()
returns numeric
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(sum(amount), 0)
  from public.expenses
  where user_id = (select auth.uid());
$$;

revoke execute on function public.get_total_expenses() from public, anon;
grant execute on function public.get_total_expenses() to authenticated;
