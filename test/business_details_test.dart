import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('business details show evidence and the invest action', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(location: '/business/al-yusra', signedIn: true),
    );
    await settle(tester);

    expect(find.text('Al-Yusra Restaurant'), findsWidgets);
    expect(find.text('Shariah Approved'), findsWidgets);
    expect(find.text('Eastleigh, Nairobi'), findsOneWidget);
    expect(find.textContaining('Invest KES'), findsOneWidget);
    expect(find.text('Halal Certificate'), findsWidgets);
    expect(find.textContaining('not making a loan'), findsOneWidget);
  });
}
