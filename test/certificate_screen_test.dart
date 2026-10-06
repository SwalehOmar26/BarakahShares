import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('certificate shows the demo share record', (tester) async {
    await tester.pumpWidget(
      buildTestApp(location: '/portfolio/inv-alyusra', signedIn: true),
    );
    await settle(tester);

    expect(find.text('BARAKAH-SHARE-0088'), findsOneWidget);
    expect(find.text('Abdullahi Hassan'), findsOneWidget);
    expect(find.text('Al-Yusra Restaurant'), findsWidgets);
    expect(find.textContaining('10,000'), findsWidgets);
    expect(find.textContaining('0.5%'), findsWidgets);
    expect(find.text('Verified'), findsWidgets);
  });
}
