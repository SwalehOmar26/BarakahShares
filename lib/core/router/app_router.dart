import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_assistant/presentation/ai_screen.dart';
import '../../features/authentication/presentation/forgot_password_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/register_screen.dart';
import '../../features/blockchain/presentation/blockchain_screen.dart';
import '../../features/businesses/presentation/business_details_screen.dart';
import '../../features/businesses/presentation/discover_screen.dart';
import '../../features/dashboard/presentation/home_screen.dart';
import '../../features/dashboard/presentation/support_screens.dart';
import '../../features/investments/presentation/invest_screen.dart';
import '../../features/investments/presentation/payment_screen.dart';
import '../../features/investments/presentation/success_screen.dart';
import '../../features/kyc/presentation/kyc_screen.dart';
import '../../features/portfolio/presentation/portfolio_screen.dart';
import '../../features/profile/presentation/help_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/scan_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/profit_allocation/presentation/profit_screen.dart';
import '../../features/receipts/presentation/receipts_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/welcome/presentation/landing_screen.dart';
import '../../features/zakat/presentation/zakat_screen.dart';
import '../../shared/models/app_user.dart';
import '../../shared/providers/providers.dart';
import '../widgets/app_shell.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final isAuthPage =
          location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.forgotPassword;
      final isWelcome =
          location == AppRoutes.landing ||
          location == AppRoutes.splash ||
          isAuthPage;
      if (auth.status == AuthStatus.unknown) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }
      if (!auth.isAuthenticated) {
        if (location == AppRoutes.splash) return AppRoutes.landing;
        return location == AppRoutes.landing || isAuthPage
            ? null
            : AppRoutes.landing;
      }
      if (isWelcome) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.landing,
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const LandingScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.discover,
                builder: (context, state) => const DiscoverScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.portfolio,
                builder: (context, state) => const PortfolioScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/business/:businessId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BusinessDetailsScreen(
          businessId: state.pathParameters['businessId']!,
        ),
      ),
      GoRoute(
        path: '/business/:businessId/invest',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            InvestScreen(businessId: state.pathParameters['businessId']!),
      ),
      GoRoute(
        path: '/business/:businessId/pay',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final amount =
              double.tryParse(state.uri.queryParameters['amount'] ?? '') ?? 0;
          final phone = state.uri.queryParameters['phone'] ?? '';
          return PaymentScreen(
            businessId: state.pathParameters['businessId']!,
            amount: amount,
            phone: phone,
          );
        },
      ),
      GoRoute(
        path: '/business/:businessId/receipts',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            ReceiptsScreen(businessId: state.pathParameters['businessId']!),
      ),
      GoRoute(
        path: '/business/:businessId/profit',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            ProfitScreen(businessId: state.pathParameters['businessId']!),
      ),
      GoRoute(
        path: '/documents/:documentId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            DocumentScreen(documentId: state.pathParameters['documentId']!),
      ),
      GoRoute(
        path: '/certificates/:certificateId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => CertificateScreen(
          certificateId: state.pathParameters['certificateId']!,
        ),
      ),
      GoRoute(
        path: '/investment-success/:reference',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => InvestmentSuccessScreen(
          reference: state.pathParameters['reference']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.assistant,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => AiAssistantScreen(
          businessId: state.uri.queryParameters['businessId'],
        ),
      ),
      GoRoute(
        path: AppRoutes.kyc,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const KycScreen(),
      ),
      GoRoute(
        path: AppRoutes.zakat,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ZakatScreen(),
      ),
      GoRoute(
        path: AppRoutes.blockchain,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const BlockchainScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.help,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.certificates,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CertificatesListScreen(),
      ),
      GoRoute(
        path: AppRoutes.scan,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ScanScreen(),
      ),
    ],
  );
});

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.status != next.status) notifyListeners();
    });
  }
}
