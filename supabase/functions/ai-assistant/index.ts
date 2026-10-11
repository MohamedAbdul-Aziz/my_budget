import 'jsr:@supabase/functions-js/edge-runtime.d.ts';
import { createClient } from 'npm:@supabase/supabase-js@2';

import {
  answerOf,
  buildMessages,
  byteLength,
  MAX_BODY_BYTES,
  parseAskRequest,
  splitReply,
} from './validate.ts';

// Answers a question about the caller's spending. The app sends a summary
// built on the phone (totals only, unless the user chose to share more);
// this function adds the AI provider's key, which never leaves the server,
// and asks the model.
//
// No account is needed. verify_jwt is OFF so guests can call it, and every
// request is counted here instead:
// * a signed-in user (a valid session token) per account, in ai_usage;
// * a guest per device id (a random id the app keeps on the phone), and
//   also per IP address, so a client that keeps changing its id is still
//   held back. The IP is only stored as a salted hash.
// The user is never told the numbers; past a limit the answer is
// 429 {error:'daily_limit'}.
//
// Secrets:
//   AI_BASE_URL  e.g. https://api.groq.com/openai/v1
//   AI_API_KEY   the provider's key
//   AI_MODEL     e.g. openai/gpt-oss-120b
//   AI_REASONING_EFFORT  optional, for reasoning models (low|medium|high):
//                low keeps answers quick and leaves room under max_tokens,
//                which reasoning tokens also count against
//   AI_IP_SALT   random text that makes the stored IP hashes unguessable
//
// Never log a request body, the summary, the prompt, an answer, an IP or a
// secret: only status codes and short error names.

/** Questions per account, or per device, per UTC day. */
const DAILY_LIMIT = 20;

/** Questions per IP address per UTC day, across every guest device on it. */
const DAILY_IP_LIMIT = 60;

const PROVIDER_TIMEOUT_MS = 30_000;

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

/** The caller's address as the platform saw it: the first hop. */
function clientIp(req: Request): string | null {
  const forwarded = req.headers.get('x-forwarded-for')?.split(',')[0]?.trim();
  return forwarded || req.headers.get('x-real-ip')?.trim() || null;
}

async function hashed(salt: string, value: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    'SHA-256',
    new TextEncoder().encode(`${salt}:${value}`),
  );
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, '0'))
    .join('');
}

Deno.serve(async (req: Request) => {
  if (req.method !== 'POST') return json({ error: 'method_not_allowed' }, 405);

  const declared = Number(req.headers.get('Content-Length') ?? '0');
  if (declared > MAX_BODY_BYTES) return json({ error: 'bad_request' }, 400);
  const raw = await req.text();
  if (byteLength(raw) > MAX_BODY_BYTES) return json({ error: 'bad_request' }, 400);

  let body: unknown;
  try {
    body = JSON.parse(raw);
  } catch {
    return json({ error: 'bad_request' }, 400);
  }
  const request = parseAskRequest(body);
  if (!request) return json({ error: 'bad_request' }, 400);

  const baseUrl = Deno.env.get('AI_BASE_URL');
  const apiKey = Deno.env.get('AI_API_KEY');
  const model = Deno.env.get('AI_MODEL');
  const reasoningEffort = Deno.env.get('AI_REASONING_EFFORT');
  const ipSalt = Deno.env.get('AI_IP_SALT');
  if (!baseUrl || !apiKey || !model || !ipSalt) {
    console.error('ai-assistant: secrets are not set');
    return json({ error: 'unavailable' }, 503);
  }

  const admin = createClient(Deno.env.get('SUPABASE_URL')!, secretKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // A real user session counts against the account. Anything else (no
  // token, the app's public key, an expired session) is a guest.
  const token = req.headers.get('Authorization')?.replace(/^Bearer\s+/i, '');
  let userId: string | null = null;
  if (token) {
    const { data, error } = await admin.auth.getUser(token);
    if (!error && data.user) userId = data.user.id;
  }

  // Counted before the provider is called, each in one atomic step. The
  // ids come from the token, the app's own device id and the connection,
  // and the limits are constants here: nothing in the body sets them.
  const checks: [string, Record<string, unknown>][] = [];
  if (userId) {
    checks.push(['bump_ai_usage', { p_uid: userId, p_limit: DAILY_LIMIT }]);
  } else {
    const ip = clientIp(req);
    if (!request.deviceId || !ip) return json({ error: 'bad_request' }, 400);
    checks.push([
      'bump_ai_guest_usage',
      { p_key: `device:${request.deviceId}`, p_limit: DAILY_LIMIT },
    ]);
    checks.push([
      'bump_ai_guest_usage',
      { p_key: `ip:${await hashed(ipSalt, ip)}`, p_limit: DAILY_IP_LIMIT },
    ]);
  }
  for (const [fn, args] of checks) {
    const { data: allowed, error } = await admin.rpc(fn, args);
    if (error) {
      console.error('ai-assistant: quota check failed:', error.code);
      return json({ error: 'unavailable' }, 503);
    }
    if (allowed !== true) return json({ error: 'daily_limit' }, 429);
  }

  let response: Response;
  try {
    response = await fetch(`${baseUrl.replace(/\/+$/, '')}/chat/completions`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model,
        messages: buildMessages(request),
        temperature: 0.3,
        max_tokens: 1500,
        ...(reasoningEffort ? { reasoning_effort: reasoningEffort } : {}),
      }),
      signal: AbortSignal.timeout(PROVIDER_TIMEOUT_MS),
    });
  } catch (error) {
    console.error(
      'ai-assistant: provider unreachable:',
      error instanceof Error ? error.name : 'unknown',
    );
    return json({ error: 'unavailable' }, 502);
  }

  if (response.status === 429) {
    await response.body?.cancel();
    return json({ error: 'busy' }, 429);
  }
  if (!response.ok) {
    await response.body?.cancel();
    console.error('ai-assistant: provider status', response.status);
    return json({ error: 'unavailable' }, 502);
  }

  let text: string | null = null;
  try {
    text = answerOf(await response.json());
  } catch {
    text = null;
  }
  const reply = text === null ? null : splitReply(text);
  if (!reply) {
    console.error('ai-assistant: provider sent no answer');
    return json({ error: 'unavailable' }, 502);
  }

  return json({ answer: reply.answer, followUps: reply.followUps }, 200);
});
