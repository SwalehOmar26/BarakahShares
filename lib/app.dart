import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/providers.dart';

class BarakahApp extends ConsumerWidget {
  const BarakahApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: 'BarakahShares',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
