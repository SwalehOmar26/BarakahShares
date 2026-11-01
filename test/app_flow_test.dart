import 'package:barakah_shares/app/app.dart';
import 'package:barakah_shares/core/constants/app_constants.dart';
import 'package:barakah_shares/core/network/api_exception.dart';
import 'package:barakah_shares/shared/data/demo_catalog.dart';
import 'package:barakah_shares/shared/models/business_opportunity.dart';
import 'package:barakah_shares/shared/providers/providers.dart';
import 'package:barakah_shares/shared/repositories/auth_repository.dart';
import 'package:barakah_shares/shared/repositories/business_repository.dart';
import 'package:barakah_shares/shared/storage/secure_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(
      AppConstants.splashHold + const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: BarakahApp()));
    await settle(tester);
    await tester.ensureVisible(find.text('I Already Have an Account'));
    await tester.tap(find.text('I Already Have an Account'));
    await tester.pumpAndSettle();
  }

  testWidgets('splash introduces BarakahShares and then opens welcome', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: BarakahApp()));
    expect(find.text('HALAL EQUITY CROWD'), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);
    await tester.pump(
      AppConstants.splashHold + const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    expect(find.text('Grow Your Wealth.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('I Already Have an Account'), findsOneWidget);
    expect(find.text('Welcome Back'), findsNothing);
  });

  testWidgets('phone login signs in with the demonstration account', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.enterText(
      find.byKey(WidgetKeys.loginPhone),
      AppConstants.demoPhone,
    );
    await tester.enterText(
      find.byKey(WidgetKeys.loginPassword),
      AppConstants.demoPassword,
    );
    await tester.tap(find.byKey(WidgetKeys.loginSubmit));
    await tester.pumpAndSettle();
    expect(find.text('KSh 50,000'), findsWidgets);
  });

  testWidgets('email login signs in with the demonstration account', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Continue with Email'));
    await tester.pumpAndSettle();
    expect(find.byKey(WidgetKeys.loginPhone), findsNothing);
    await tester.enterText(
      find.byKey(WidgetKeys.loginEmail),
      AppConstants.demoEmail,
    );
    await tester.enterText(
      find.byKey(WidgetKeys.loginPassword),
      AppConstants.demoPassword,
    );
    await tester.tap(find.byKey(WidgetKeys.loginSubmit));
    await tester.pumpAndSettle();
    expect(find.text('KSh 50,000'), findsWidgets);
  });

  testWidgets('login and registration navigate to each other', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    expect(find.text('Join BarakahShares'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Continue with Email'), findsOneWidget);
  });

  testWidgets(
    'registration rejects an invalid email and a mismatched password',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(WidgetKeys.registerName),
        'Amina Hassan',
      );
      await tester.enterText(
        find.byKey(WidgetKeys.registerPhone),
        '+254712345679',
      );
      await tester.enterText(
        find.byKey(WidgetKeys.registerEmail),
        'not-an-email',
      );
      await tester.enterText(
        find.byKey(WidgetKeys.registerPassword),
        AppConstants.demoPassword,
      );
      await tester.enterText(
        find.byKey(WidgetKeys.registerConfirm),
        'Barakah2',
      );
      await tester.ensureVisible(find.byKey(WidgetKeys.registerSubmit));
      await tester.tap(find.byKey(WidgetKeys.registerSubmit));
      await tester.pump();
      expect(find.text('Enter a valid email address'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
      expect(
        find.text('Accept the Terms and Conditions to continue.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('registration accepts a valid email address', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(WidgetKeys.registerName), 'Yusuf Ali');
    await tester.enterText(
      find.byKey(WidgetKeys.registerPhone),
      '+254711000111',
    );
    await tester.enterText(
      find.byKey(WidgetKeys.registerEmail),
      'yusuf@example.com',
    );
    await tester.enterText(
      find.byKey(WidgetKeys.registerPassword),
      AppConstants.demoPassword,
    );
    await tester.enterText(
      find.byKey(WidgetKeys.registerConfirm),
      AppConstants.demoPassword,
    );
    await tester.ensureVisible(find.byKey(WidgetKeys.registerTerms));
    await tester.tap(find.byKey(WidgetKeys.registerTerms));
    await tester.pump();
    await tester.ensureVisible(find.byKey(WidgetKeys.registerSubmit));
    await tester.tap(find.byKey(WidgetKeys.registerSubmit));
    await tester.pumpAndSettle();
    expect(find.text('Join BarakahShares'), findsNothing);
    expect(find.text('Your halal investments, your future'), findsOneWidget);
  });

  testWidgets('invalid login stays on the form', (tester) async {
    await pumpApp(tester);
    await tester.enterText(find.byKey(WidgetKeys.loginPhone), '123');
    await tester.enterText(find.byKey(WidgetKeys.loginPassword), 'short');
    await tester.tap(find.byKey(WidgetKeys.loginSubmit));
    await tester.pump();
    expect(find.text('Enter a valid Kenyan mobile number'), findsOneWidget);
    expect(find.text('KSh 50,000'), findsNothing);
  });

  testWidgets('demo portfolio shows the sample investment totals', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(WidgetKeys.demoLogin));
    await tester.pumpAndSettle();
    expect(find.text('KSh 50,000'), findsWidgets);
    expect(tester.widget<Text>(find.byKey(WidgetKeys.totalShares)).data, '500');
    expect(
      tester.widget<Text>(find.byKey(WidgetKeys.totalBusinesses)).data,
      '4',
    );
    expect(
      tester.widget<Text>(find.byKey(WidgetKeys.activeCampaigns)).data,
      '3',
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('business-card-alyusra')),
      400,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('home-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Al-Yusra Restaurant'), findsWidgets);
  });

  testWidgets(
    'cancelled and failed checkouts are not confirmed contributions',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byKey(WidgetKeys.demoLogin));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('business-card-alyusra')),
        400,
        scrollable: find
            .descendant(
              of: find.byKey(const Key('home-scroll')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.byKey(const ValueKey('business-card-alyusra')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invest Now'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(WidgetKeys.amount5000));
      await tester.tap(find.byKey(WidgetKeys.amount5000));
      await tester.pump();
      await tester.ensureVisible(find.byKey(WidgetKeys.investTerms));
      await tester.tap(find.byKey(WidgetKeys.investTerms));
      await tester.pump();
      await tester.ensureVisible(find.byKey(WidgetKeys.investSubmit));
      await tester.tap(find.byKey(WidgetKeys.investSubmit));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Payment pending'), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.payCancel));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Payment cancelled'), findsOneWidget);
      expect(find.text('Contribution Successful'), findsNothing);

      await tester.tap(find.byKey(WidgetKeys.payBack));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.ensureVisible(find.byKey(WidgetKeys.investSubmit));
      await tester.tap(find.byKey(WidgetKeys.investSubmit));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(WidgetKeys.payFail));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Payment failed'), findsOneWidget);
      expect(find.text('Contribution Successful'), findsNothing);

      await tester.tap(find.byKey(WidgetKeys.payBack));
      await tester.pump();
      await tester.tap(find.byKey(WidgetKeys.paySuccess));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('Contribution Successful'), findsOneWidget);
      expect(find.textContaining('not legally issued equity'), findsOneWidget);
    },
  );

  testWidgets('discover and assistant are reachable from the shell', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(WidgetKeys.demoLogin));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Discover'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Baraka Cold Chain'), findsOneWidget);
    await tester.tap(find.text('Restaurants'));
    await tester.pump();
    expect(find.text('Al-Yusra Restaurant'), findsWidgets);
    expect(find.text('Baraka Cold Chain'), findsNothing);
  });

  testWidgets('campaign loading errors are visible', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            MockAuthRepository(
              MemorySecureStore(),
              initialUser: DemoCatalog.demoUser,
            ),
          ),
          businessRepositoryProvider.overrideWithValue(
            _FailingBusinessRepository(),
          ),
        ],
        child: const BarakahApp(),
      ),
    );
    await settle(tester);
    expect(find.text('Network unavailable'), findsOneWidget);
  });
}

class _FailingBusinessRepository implements BusinessRepository {
  @override
  Future<List<BusinessOpportunity>> fetchBusinesses() async {
    throw const ApiException('Network unavailable');
  }

  @override
  Future<BusinessOpportunity> fetchCampaign(String id) async {
    throw const ApiException('Network unavailable');
  }
}
