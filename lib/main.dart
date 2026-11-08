import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'core/supabase/supabase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Clean URLs such as /services instead of /#/services (ADR-003).
  usePathUrlStrategy();
  // Exposes the semantics tree on the web for assistive technology
  // (NFR-010, NFR-011). Verify with a screen reader (TC-032).
  SemanticsBinding.instance.ensureSemantics();
  await initialiseSupabase();
  runApp(const ProviderScope(child: NexoraApp()));
}
