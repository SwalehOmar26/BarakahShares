import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('login screen accepts the demo account', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pump();

    expect(find.text('Welcome to BarakahShares'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('phone-field')), '700000000');
    await tester.enterText(find.byKey(const Key('password-field')), 'Demo1234');
    await tester.tap(find.byKey(const Key('login-button')));
    await settle(tester);

    expect(find.textContaining('Abdullahi'), findsWidgets);
  });
}
