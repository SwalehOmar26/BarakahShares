import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/phone_preview.dart';

class BarakahApp extends ConsumerWidget {
  const BarakahApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'BarakahShares',
      theme: AppTheme.light(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return PhonePreview(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
