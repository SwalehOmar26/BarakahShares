import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('discover lists vetted businesses', (tester) async {
    await tester.pumpWidget(
      buildTestApp(location: '/discover', signedIn: true),
    );
    await settle(tester);

    expect(find.text('Regulated Businesses'), findsOneWidget);
    expect(find.text('Al-Yusra Restaurant'), findsWidgets);
    expect(find.text('Amani Abaya Shop'), findsWidgets);
    expect(find.text('Halal Certified'), findsWidgets);
    expect(find.textContaining('Illustrative'), findsWidgets);
  });
}
