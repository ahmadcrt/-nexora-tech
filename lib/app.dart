import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class NexoraApp extends StatefulWidget {
  const NexoraApp({super.key});

  @override
  State<NexoraApp> createState() => _NexoraAppState();
}

class _NexoraAppState extends State<NexoraApp> {
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NEXORA TECH',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
