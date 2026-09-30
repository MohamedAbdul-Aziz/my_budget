-- Income tracking (app schema version 3): every category is either spending
-- or income, and a transaction is whichever type its category is.
--
-- The cloud tables mirror the phone's SQLite columns, so a phone on the new
-- version uploads `type` with every category. Without this column those
-- upserts fail. Rows uploaded by older versions of the app carry no type
-- and are spending, which is what the default says.
alter table public.categories
  add column if not exists type text not null default 'expense';

alter table public.categories
  drop constraint if exists categories_type_check;

alter table public.categories
  add constraint categories_type_check check (type in ('expense', 'income'));
