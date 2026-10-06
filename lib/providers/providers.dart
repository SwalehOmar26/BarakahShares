import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_env.dart';
import '../core/errors/app_exception.dart';
import '../core/services/api_client.dart';
import '../core/services/secure_store.dart';
import '../models/blockchain_transaction.dart';
import '../models/business.dart';
import '../models/enums.dart';
import '../models/investment.dart';
import '../models/investor.dart';
import '../models/kyc_status.dart';
import '../models/profit_distribution.dart';
import '../models/receipt.dart';
import '../models/records.dart';
import '../models/share_certificate.dart';
import '../repositories/auth_service.dart';
import '../repositories/blockchain_service.dart';
import '../repositories/business_repository.dart';
import '../repositories/certificate_repository.dart';
import '../repositories/document_verification_service.dart';
import '../repositories/investment_repository.dart';
import '../repositories/kyc_service.dart';
import '../repositories/payment_service.dart';
import '../repositories/profit_repository.dart';
import '../repositories/zakat_service.dart';
import '../repositories/live/daraja_payment_service.dart';
import '../repositories/live/smile_id_kyc_service.dart';
import '../repositories/mock/demo_database.dart';
import '../repositories/mock/mock_auth_service.dart';
import '../repositories/mock/mock_kyc_service.dart';
import '../repositories/mock/mock_repositories.dart';
import '../repositories/mock/mock_services.dart';

class DemoTiming {
  const DemoTiming({
    this.repository = const Duration(milliseconds: 220),
    this.payment = const Duration(milliseconds: 1100),
    this.auth = const Duration(milliseconds: 280),
    this.splash = const Duration(seconds: 2),
  });

  final Duration repository;
  final Duration payment;
  final Duration auth;
  final Duration splash;
}

class AuthState {
  const AuthState({this.user, this.isLoading = false, this.error});

  final Investor? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    Investor? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    this.mfaEnabled = false,
  });

  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final bool mfaEnabled;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? biometricEnabled,
    bool? mfaEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
    );
  }
}

class PortfolioSnapshot {
  const PortfolioSnapshot({required this.summary, required this.investments});

  final PortfolioSummary summary;
  final List<Investment> investments;
}

final demoTimingProvider = Provider<DemoTiming>((ref) => const DemoTiming());

final initialLocationProvider = Provider<String>((ref) => '/splash');

final initialAuthProvider = Provider<AuthState>((ref) => const AuthState());

final secureStoreProvider = Provider<SecureStore>(
  (ref) => FlutterSecureStore(),
);

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final demoDatabaseProvider = Provider<DemoDatabase>((ref) => DemoDatabase());

final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService(
    ref.watch(secureStoreProvider),
    delay: ref.watch(demoTimingProvider).auth,
  );
});

final kycServiceProvider = Provider<KycService>((ref) {
  if (AppEnv.smileReady) return SmileIdKycService();
  return MockKycService(delay: ref.watch(demoTimingProvider).auth);
});

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return MockBusinessRepository(
    ref.watch(demoDatabaseProvider),
    delay: ref.watch(demoTimingProvider).repository,
  );
});

final investmentRepositoryProvider = Provider<InvestmentRepository>((ref) {
  return MockInvestmentRepository(
    ref.watch(demoDatabaseProvider),
    delay: ref.watch(demoTimingProvider).repository,
  );
});

final profitRepositoryProvider = Provider<ProfitRepository>((ref) {
  return MockProfitRepository(
    ref.watch(demoDatabaseProvider),
    delay: ref.watch(demoTimingProvider).repository,
  );
});

final certificateRepositoryProvider = Provider<CertificateRepository>((ref) {
  return MockCertificateRepository(
    ref.watch(demoDatabaseProvider),
    delay: ref.watch(demoTimingProvider).repository,
  );
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  if (AppEnv.darajaReady) return DarajaPaymentService();
  return MockPaymentService(delay: ref.watch(demoTimingProvider).payment);
});

final blockchainServiceProvider = Provider<BlockchainService>((ref) {
  return MockBlockchainService(
    ref.watch(demoDatabaseProvider),
    delay: ref.watch(demoTimingProvider).repository,
  );
});

final documentVerificationProvider = Provider<DocumentVerificationService>((
  ref,
) {
  return MockDocumentVerificationService(ref.watch(demoDatabaseProvider));
});

final zakatServiceProvider = Provider<ZakatService>(
  (ref) => const MockZakatService(),
);

final lastContributionProvider = StateProvider<ContributionRecord?>(
  (ref) => null,
);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setTheme(ThemeMode mode) => state = state.copyWith(themeMode: mode);

  void setNotifications(bool value) =>
      state = state.copyWith(notificationsEnabled: value);

  void setBiometric(bool value) =>
      state = state.copyWith(biometricEnabled: value);

  void setMfa(bool value) => state = state.copyWith(mfaEnabled: value);
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => ref.watch(initialAuthProvider);

  Future<bool> login({
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await ref
          .read(authServiceProvider)
          .login(phone: phone, password: password, role: role);
      state = AuthState(user: user);
      return true;
    } on AppException catch (error) {
      state = AuthState(error: error.message);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await ref
          .read(authServiceProvider)
          .register(name: name, phone: phone, password: password, role: role);
      state = AuthState(user: user);
      return true;
    } on AppException catch (error) {
      state = AuthState(error: error.message);
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).logout();
    state = const AuthState();
  }

  Future<void> markKyc(KycStatus status) async {
    final current = state.user;
    if (current == null) return;
    final updated = current.copyWith(kycStatus: status);
    await ref.read(authServiceProvider).updateInvestor(updated);
    state = AuthState(user: updated);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

final businessesProvider = FutureProvider<List<Business>>((ref) {
  return ref.watch(businessRepositoryProvider).fetchBusinesses();
});

final businessProvider = FutureProvider.family<Business?, String>((ref, id) {
  return ref.watch(businessRepositoryProvider).fetchBusiness(id);
});

final documentsProvider = FutureProvider.family<List<BusinessDocument>, String>(
  (ref, id) {
    return ref.watch(businessRepositoryProvider).fetchDocuments(id);
  },
);

final receiptsProvider = FutureProvider.family<List<Receipt>, String>((
  ref,
  id,
) {
  return ref.watch(businessRepositoryProvider).fetchReceipts(id);
});

final profitProvider = FutureProvider.family<ProfitDistribution?, String>((
  ref,
  id,
) {
  return ref.watch(profitRepositoryProvider).fetchLatest(id);
});

final chainProvider =
    FutureProvider.family<List<BlockchainTransaction>, String>((ref, id) {
      return ref.watch(blockchainServiceProvider).fetchTransactions(id);
    });

final certificateProvider = FutureProvider.family<ShareCertificate?, String>((
  ref,
  investmentId,
) {
  return ref
      .watch(certificateRepositoryProvider)
      .fetchByInvestment(investmentId);
});

final activitiesProvider = FutureProvider<List<ActivityItem>>((ref) {
  return ref.watch(investmentRepositoryProvider).fetchActivity();
});

class PortfolioController extends AsyncNotifier<PortfolioSnapshot> {
  @override
  Future<PortfolioSnapshot> build() async {
    final user = ref.watch(authControllerProvider).user;
    if (user == null) {
      return const PortfolioSnapshot(
        summary: PortfolioSummary(
          totalInvestedKes: 0,
          totalDividendsKes: 0,
          activeBusinesses: 0,
          dividendHistory: [],
        ),
        investments: [],
      );
    }
    final repo = ref.watch(investmentRepositoryProvider);
    final investments = await repo.fetchInvestments(user.id);
    final summary = await repo.fetchPortfolio(user.id);
    return PortfolioSnapshot(summary: summary, investments: investments);
  }

  Future<Investment> invest({
    required String businessId,
    required int amountKes,
    required String txHash,
  }) async {
    final user = ref.read(authControllerProvider).user;
    if (user == null) {
      throw const AppException('Sign in before investing.');
    }
    final investment = await ref
        .read(investmentRepositoryProvider)
        .recordInvestment(
          investorId: user.id,
          investorName: user.name,
          businessId: businessId,
          amountKes: amountKes,
          txHash: txHash,
        );
    ref.invalidateSelf();
    ref.invalidate(businessesProvider);
    ref.invalidate(businessProvider(businessId));
    ref.invalidate(profitProvider(businessId));
    ref.invalidate(chainProvider(businessId));
    ref.invalidate(activitiesProvider);
    ref.invalidate(certificateProvider(investment.id));
    await future;
    return investment;
  }
}

final portfolioProvider =
    AsyncNotifierProvider<PortfolioController, PortfolioSnapshot>(
      PortfolioController.new,
    );

class KycController extends AsyncNotifier<KycRecord> {
  @override
  Future<KycRecord> build() async {
    final user = ref.watch(authControllerProvider).user;
    if (user == null) {
      return const KycRecord(
        status: KycStatus.notStarted,
        idUploaded: false,
        selfieCaptured: false,
      );
    }
    return ref
        .read(kycServiceProvider)
        .statusFor(
          user.id,
          alreadyVerified: user.kycStatus == KycStatus.verified,
        );
  }

  Future<void> uploadId() => _apply((service, id) => service.uploadId(id));

  Future<void> captureSelfie() =>
      _apply((service, id) => service.captureSelfie(id));

  Future<void> startVerification() =>
      _apply((service, id) => service.startVerification(id));

  Future<void> _apply(
    Future<KycRecord> Function(KycService service, String userId) action,
  ) async {
    final user = ref.read(authControllerProvider).user;
    if (user == null) {
      throw const AppException('Sign in before verification.');
    }
    state = const AsyncLoading();
    final record = await action(ref.read(kycServiceProvider), user.id);
    state = AsyncData(record);
    if (record.status != user.kycStatus) {
      await ref.read(authControllerProvider.notifier).markKyc(record.status);
    }
  }
}

final kycControllerProvider = AsyncNotifierProvider<KycController, KycRecord>(
  KycController.new,
);

final zakatEstimateProvider = Provider<ZakatEstimate>((ref) {
  final portfolio = ref.watch(portfolioProvider).asData?.value;
  final invested = portfolio?.summary.totalInvestedKes ?? 0;
  return ref
      .watch(zakatServiceProvider)
      .estimate(portfolioValueKes: invested, eligibleAssetsKes: invested);
});
