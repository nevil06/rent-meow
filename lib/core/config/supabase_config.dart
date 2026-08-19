/// Centralized Supabase configuration for MyManager.
///
/// You can configure these keys either by:
/// 1. Directly pasting your Supabase Project URL and Anon Key below, OR
/// 2. Passing them via build flags:
///    `flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
class SupabaseConfig {
  /// Your Supabase project URL (e.g. 'https://xyzcompany.supabase.co')
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '', // Paste your Supabase URL here if not using --dart-define
  );

  /// Your Supabase anon / public API key
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '', // Paste your Supabase anon key here if not using --dart-define
  );

  /// Returns true if valid Supabase credentials have been configured.
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty &&
        supabaseAnonKey.isNotEmpty &&
        supabaseUrl.startsWith('http');
  }
}
