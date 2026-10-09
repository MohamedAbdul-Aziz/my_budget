import 'jsr:@supabase/functions-js/edge-runtime.d.ts';
import { createClient } from 'npm:@supabase/supabase-js@2';

import {
  answerOf,
  buildMessages,
  byteLength,
  MAX_BODY_BYTES,
  parseAskRequest,
} from './validate.ts';

// Answers a question about the caller's spending. The app sends a small
// summary of totals (never single transactions); this function adds the AI
// provider's key, which never leaves the server, and asks the model.
//
// verify_jwt is on, so the platform has already turned away any request
// without a valid session before this code runs. The user is still read
// from the token here, because the quota is kept per user.
//
// Provider: any OpenAI-compatible chat completions API, chosen by secrets:
//   AI_BASE_URL  e.g. https://api.groq.com/openai/v1
//   AI_API_KEY   the provider's key
//   AI_MODEL     e.g. openai/gpt-oss-120b
//   AI_REASONING_EFFORT  optional, for reasoning models (low|medium|high):
//                low keeps answers quick and leaves room under max_tokens,
//                which reasoning tokens also count against
//
// Never log a request body, the summary, the prompt, an answer or a secret:
// only status codes and short error names.

/** Questions per account per UTC day (see the ai_usage migration). */
const DAILY_LIMIT = 20;

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

Deno.serve(async (req: Request) => {
  if (req.method !== 'POST') return json({ error: 'method_not_allowed' }, 405);

  const token = req.headers.get('Authorization')?.replace(/^Bearer\s+/i, '');
  if (!token) return json({ error: 'not_signed_in' }, 401);

  const admin = createClient(Deno.env.get('SUPABASE_URL')!, secretKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // The account comes from the caller's own session token, never from the
  // request body.
  const {
    data: { user },
    error: userError,
  } = await admin.auth.getUser(token);
  if (userError || !user) return json({ error: 'not_signed_in' }, 401);

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
  if (!baseUrl || !apiKey || !model) {
    console.error('ai-assistant: provider secrets are not set');
    return json({ error: 'unavailable' }, 503);
  }

  // Counted before the provider is called, in one atomic step.
  const { data: allowed, error: quotaError } = await admin.rpc(
    'bump_ai_usage',
    { p_uid: user.id, p_limit: DAILY_LIMIT },
  );
  if (quotaError) {
    console.error('ai-assistant: quota check failed:', quotaError.code);
    return json({ error: 'unavailable' }, 503);
  }
  if (allowed !== true) return json({ error: 'daily_limit' }, 429);

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

  let answer: string | null = null;
  try {
    answer = answerOf(await response.json());
  } catch {
    answer = null;
  }
  if (!answer) {
    console.error('ai-assistant: provider sent no answer');
    return json({ error: 'unavailable' }, 502);
  }

  return json({ answer }, 200);
});
