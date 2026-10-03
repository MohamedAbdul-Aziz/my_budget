create or replace function public.add_expense(
  p_title text,
  p_amount numeric
)
returns public.expenses
language plpgsql
as $$
declare
  new_expense public.expenses;
begin
  insert into public.expenses (title, amount)
  values (p_title, p_amount)
  returning * into new_expense;

  return new_expense;
end;
$$
