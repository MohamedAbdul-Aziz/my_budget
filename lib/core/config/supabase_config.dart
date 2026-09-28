/// Connection details for the MyBudget Supabase project.
///
/// The publishable key is meant to ship inside the app: it only grants what the
/// row level security policies allow, so it is not a secret. Never put the
/// secret (service role) key here.
abstract final class SupabaseConfig {
  static const String url = 'https://tpyhnldnvpfewyrzvywt.supabase.co';

  static const String publishableKey =
      'sb_publishable_MKfZYVub4wkD_f8U5GGnyg_V3yH-KwG';
}
