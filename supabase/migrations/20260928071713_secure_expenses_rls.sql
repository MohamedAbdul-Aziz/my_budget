ALTER TABLE public.expenses
  ADD COLUMN user_id uuid NOT NULL DEFAULT auth.uid()
    REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE INDEX expenses_user_id_idx ON public.expenses(user_id);

ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public.expenses FROM anon;

CREATE POLICY expenses_select_own ON public.expenses
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = user_id);

CREATE POLICY expenses_insert_own ON public.expenses
  FOR INSERT TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY expenses_update_own ON public.expenses
  FOR UPDATE TO authenticated
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY expenses_delete_own ON public.expenses
  FOR DELETE TO authenticated
  USING ((select auth.uid()) = user_id);
