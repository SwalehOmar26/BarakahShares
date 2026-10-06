import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('profit allocation shows the illustrative KES 800 share', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(location: '/profit/al-yusra', signedIn: true),
    );
    await settle(tester);

    expect(find.text('Profit Distribution'), findsOneWidget);
    expect(find.textContaining('400,000'), findsWidgets);
    expect(find.textContaining('160,000'), findsWidgets);
    expect(find.textContaining('800'), findsWidgets);
    expect(
      find.textContaining(
        'Illustrative distribution based on the approved monthly profit.',
      ),
      findsOneWidget,
    );
    expect(find.text('Withdraw via M-PESA'), findsOneWidget);
  });
}
