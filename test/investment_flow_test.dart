import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('investment flow records a demo M-PESA payment', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(
      buildTestApp(location: '/invest/al-yusra', signedIn: true),
    );
    await settle(tester);

    expect(find.textContaining('Invest in Al-Yusra'), findsOneWidget);
    final button = find.byKey(const Key('proceed-mpesa')).hitTestable();
    await tester.tap(button);
    await tester.pump();
    await tester.tap(find.text('Confirm'));
    await settle(tester);

    expect(find.text('Contribution Successful'), findsOneWidget);
    expect(find.textContaining('Amanah as Code'), findsOneWidget);
    expect(find.text('Confirmed'), findsWidgets);
  });
}
