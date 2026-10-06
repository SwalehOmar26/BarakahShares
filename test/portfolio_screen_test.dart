import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('portfolio shows the demo holdings', (tester) async {
    await tester.pumpWidget(
      buildTestApp(location: '/portfolio', signedIn: true),
    );
    await settle(tester);

    expect(find.text('My Portfolio'), findsOneWidget);
    expect(find.textContaining('50,000'), findsWidgets);
    expect(find.textContaining('4,200'), findsWidgets);
    expect(find.text('Al-Yusra Restaurant'), findsWidgets);
    expect(find.text('BARAKAH-SHARE-0088'), findsOneWidget);
  });
}
