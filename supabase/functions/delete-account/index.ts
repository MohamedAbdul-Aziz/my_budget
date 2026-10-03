import 'jsr:@supabase/functions-js/edge-runtime.d.ts';
import { createClient } from 'npm:@supabase/supabase-js@2';

// Deletes the calling user's own account. Their categories, expenses and
// settings go with it: every app table references auth.users with
// `on delete cascade`.
//
// verify_jwt is on, so the platform has already turned away any request
// without a valid user session before this code runs.

function secretKey(): string {
  // Projects on the new API keys expose them as JSON keyed by name; older
  // projects only have the legacy service role key.
  const keys = Deno.env.get('SUPABASE_SECRET_KEYS');
  if (keys) return JSON.parse(keys)['default'];
  return Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
}

function json(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method !== 'POST') return json({ error: 'method_not_allowed' }, 405);

  const token = req.headers.get('Authorization')?.replace(/^Bearer\s+/i, '');
  if (!token) return json({ error: 'not_signed_in' }, 401);

  const admin = createClient(Deno.env.get('SUPABASE_URL')!, secretKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // The account to delete comes from the caller's own session token, never
  // from the request body, so nobody can delete someone else's account.
  const {
    data: { user },
    error: userError,
  } = await admin.auth.getUser(token);
  if (userError || !user) return json({ error: 'not_signed_in' }, 401);

  const { error } = await admin.auth.admin.deleteUser(user.id);
  if (error) {
    console.error('delete-account failed:', error.message);
    return json({ error: 'delete_failed' }, 500);
  }

  return json({ deleted: true }, 200);
});
