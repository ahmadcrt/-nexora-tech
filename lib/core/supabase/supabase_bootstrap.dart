import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// Initialises Supabase when it has been configured.
///
/// Without configuration the application still runs; features that need the
/// backend report themselves as unavailable instead of failing.
Future<void> initialiseSupabase() async {
  if (!AppConfig.hasSupabase) {
    return;
  }
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
}
