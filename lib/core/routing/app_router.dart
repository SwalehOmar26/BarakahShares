import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/activity_screen.dart';
import '../../features/auth/kyc_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/blockchain/blockchain_screen.dart';
import '../../features/blockchain/scan_screen.dart';
import '../../features/business_details/business_details_screen.dart';
import '../../features/discover/discover_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/investment/invest_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/portfolio/holding_screen.dart';
import '../../features/portfolio/portfolio_screen.dart';
import '../../features/profile/info_screen.dart';
import '../../features/profile/integrations_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profit/profit_screen.dart';
import '../../features/receipts/receipts_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/success/success_screen.dart';
import '../../features/zakat/zakat_screen.dart';
import '../../models/enums.dart';
import '../../providers/providers.dart';
import 'routes.dart';

class RouterRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh();
  ref.onDispose(refresh.dispose);
  ref.listen(authControllerProvider, (_, _) => refresh.ping());

  final router = GoRouter(
    initialLocation: ref.read(initialLocationProvider),
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final isPublic =
          location == AppRoutes.splash ||
          location == AppRoutes.login ||
          location == AppRoutes.register;
      if (!auth.isAuthenticated) {
        return isPublic ? null : AppRoutes.login;
      }
      if (location == AppRoutes.splash ||
          location == AppRoutes.login ||
          location == AppRoutes.register) {
        final verified = auth.user?.kycStatus == KycStatus.verified;
        return verified ? AppRoutes.home : AppRoutes.kyc;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.kyc,
        name: 'kyc',
        builder: (context, state) => const KycScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.discover,
                name: 'discover',
                builder: (context, state) => const DiscoverScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.portfolio,
                name: 'portfolio',
                builder: (context, state) => const PortfolioScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.activity,
                name: 'activity',
                builder: (context, state) => const ActivityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/business/:id',
        name: 'business',
        pageBuilder: (context, state) => _fade(
          state,
          BusinessDetailsScreen(businessId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/invest/:id',
        name: 'invest',
        pageBuilder: (context, state) =>
            _fade(state, InvestScreen(businessId: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/portfolio/:id',
        name: 'holding',
        pageBuilder: (context, state) => _fade(
          state,
          HoldingScreen(investmentId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/receipts/:id',
        name: 'receipts',
        pageBuilder: (context, state) => _fade(
          state,
          ReceiptsScreen(businessId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/profit/:id',
        name: 'profit',
        pageBuilder: (context, state) =>
            _fade(state, ProfitScreen(businessId: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/blockchain/:id',
        name: 'blockchain',
        pageBuilder: (context, state) => _fade(
          state,
          BlockchainScreen(businessId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.zakat,
        name: 'zakat',
        pageBuilder: (context, state) => _fade(state, const ZakatScreen()),
      ),
      GoRoute(
        path: AppRoutes.success,
        name: 'success',
        pageBuilder: (context, state) => _fade(state, const SuccessScreen()),
      ),
      GoRoute(
        path: AppRoutes.scan,
        name: 'scan',
        pageBuilder: (context, state) => _fade(state, const ScanScreen()),
      ),
      GoRoute(
        path: AppRoutes.integrations,
        name: 'integrations',
        pageBuilder: (context, state) =>
            _fade(state, const IntegrationsScreen()),
      ),
      GoRoute(
        path: '/info/:page',
        name: 'info',
        pageBuilder: (context, state) =>
            _fade(state, InfoScreen(page: state.pathParameters['page']!)),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondary, child) {
      final offset = Tween<Offset>(
        begin: const Offset(0, 0.03),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: offset, child: child),
      );
    },
  );
}
