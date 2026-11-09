/// Build-time configuration, supplied with `--dart-define`.
///
/// No secrets belong in this repository (decision D-009). The Supabase anon
/// key is public by design and is only safe because Row Level Security is
/// enabled on every table (NT-DOC-06 Section 7). The service-role key must
/// never be used in this application.
abstract final class AppConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Public enquiries stay off until the Founder & CEO has verified the
  /// database security (supabase/verification/rls_checks.sql) and sets the
  /// repository variable ENQUIRIES_ENABLED to `true`. Any other value is off.
  static const bool enquiriesEnabled = bool.fromEnvironment('ENQUIRIES_ENABLED');

  /// True only when both Supabase values were provided at build time.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// True only when Supabase is configured AND public enquiries were
  /// explicitly switched on.
  static bool get publicEnquiriesActive => hasSupabase && enquiriesEnabled;
}
