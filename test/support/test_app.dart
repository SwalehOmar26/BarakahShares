import 'package:barakah_shares/app.dart';
import 'package:barakah_shares/core/services/secure_store.dart';
import 'package:barakah_shares/providers/providers.dart';
import 'package:barakah_shares/repositories/mock/mock_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestApp({String location = '/login', bool signedIn = false}) {
  return ProviderScope(
    overrides: [
      initialLocationProvider.overrideWithValue(location),
      secureStoreProvider.overrideWithValue(MemorySecureStore()),
      demoTimingProvider.overrideWithValue(
        const DemoTiming(
          repository: Duration.zero,
          payment: Duration.zero,
          auth: Duration.zero,
          splash: Duration.zero,
        ),
      ),
      if (signedIn)
        initialAuthProvider.overrideWithValue(
          const AuthState(user: MockAuthService.demoInvestor),
        ),
    ],
    child: const BarakahApp(),
  );
}

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 600));
}

void useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
