import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_config.dart';
import '../../core/network/dio_client.dart';
import '../data/demo_catalog.dart';
import '../models/app_user.dart';
import '../models/business_opportunity.dart';
import '../models/kyc_state.dart';
import '../models/records.dart';
import '../repositories/auth_repository.dart';
import '../repositories/business_repository.dart';
import '../repositories/insight_repositories.dart';
import '../repositories/investment_repository.dart';
import '../repositories/payment_repository.dart';
import '../storage/secure_store.dart';

final secureStoreProvider = Provider<SecureStore>((ref) {
  return ResilientSecureStore(FlutterSecureStore());
});

final dioProvider = Provider<Dio>((ref) {
  return createDio(store: ref.watch(secureStoreProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return buildAuthRepository(
    remote: ApiConfig.useRemoteApi,
    dio: ref.watch(dioProvider),
    store: ref.watch(secureStoreProvider),
  );
});

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return buildBusinessRepository(
    remote: ApiConfig.useRemoteApi,
    dio: ref.watch(dioProvider),
  );
});

final investmentRepositoryProvider = Provider<InvestmentRepository>((ref) {
  return buildInvestmentRepository(
    remote: ApiConfig.useRemoteApi,
    dio: ref.watch(dioProvider),
  );
});

final ownershipRepositoryProvider = Provider<OwnershipRepository>((ref) {
  return buildOwnershipRepository(
    remote: ApiConfig.useRemoteApi,
    dio: ref.watch(dioProvider),
    investments: ref.watch(investmentRepositoryProvider),
  );
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return buildPaymentRepository(
    remote: ApiConfig.useRemoteApi,
    dio: ref.watch(dioProvider),
    investments: ref.watch(investmentRepositoryProvider),
  );
});

final profitRepositoryProvider = Provider<ProfitRepository>((ref) {
  return buildProfitRepository(
    remote: ApiConfig.useRemoteApi,
    dio: ref.watch(dioProvider),
  );
});

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return buildDocumentRepository(
    remote: ApiConfig.useRemoteApi,
    dio: ref.watch(dioProvider),
  );
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return buildAiRepository(
    remote: ApiConfig.useRemoteApi,
    dio: ref.watch(dioProvider),
  );
});

final blockchainRepositoryProvider = Provider<BlockchainRepository>((ref) {
  return buildBlockchainRepository(
    remote: ApiConfig.useRemoteApi,
    dio: ref.watch(dioProvider),
  );
});

AuthRepository buildAuthRepository({
  required bool remote,
  required Dio dio,
  required SecureStore store,
}) {
  if (remote) return RemoteAuthRepository(dio, store);
  return MockAuthRepository(store);
}

BusinessRepository buildBusinessRepository({
  required bool remote,
  required Dio dio,
}) {
  if (remote) return RemoteBusinessRepository(dio);
  return MockBusinessRepository();
}

InvestmentRepository buildInvestmentRepository({
  required bool remote,
  required Dio dio,
}) {
  if (remote) return RemoteInvestmentRepository(dio);
  return MockInvestmentRepository();
}

OwnershipRepository buildOwnershipRepository({
  required bool remote,
  required Dio dio,
  required InvestmentRepository investments,
}) {
  if (remote) return RemoteOwnershipRepository(dio);
  return MockOwnershipRepository(investments);
}

PaymentRepository buildPaymentRepository({
  required bool remote,
  required Dio dio,
  required InvestmentRepository investments,
}) {
  if (remote) return RemotePaymentRepository(dio);
  return MockPaymentRepository(investments);
}

ProfitRepository buildProfitRepository({
  required bool remote,
  required Dio dio,
}) {
  if (remote) return RemoteProfitRepository(dio);
  return MockProfitRepository();
}

DocumentRepository buildDocumentRepository({
  required bool remote,
  required Dio dio,
}) {
  if (remote) return RemoteDocumentRepository(dio);
  return MockDocumentRepository();
}

AiRepository buildAiRepository({required bool remote, required Dio dio}) {
  if (remote) return RemoteAiRepository(dio);
  return MockAiRepository();
}

BlockchainRepository buildBlockchainRepository({
  required bool remote,
  required Dio dio,
}) {
  if (remote) return RemoteBlockchainRepository(dio);
  return MockBlockchainRepository();
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future<void>.delayed(AppConstants.splashHold, restore);
    return const AuthState.unknown();
  }

  Future<void> restore() async {
    try {
      final user = await ref.read(authRepositoryProvider).currentSession();
      if (state.isAuthenticated) return;
      state = user == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(user);
    } on Object {
      if (state.isAuthenticated) return;
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({
    String? phone,
    String? email,
    required String password,
  }) async {
    state = AuthState(status: AuthStatus.unauthenticated, busy: true);
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(phone: phone, email: email, password: password);
      state = AuthState.authenticated(user);
    } on Object catch (error) {
      state = AuthState.unauthenticated(error: _message(error));
    }
  }

  Future<void> register(RegistrationDraft draft) async {
    state = AuthState(status: AuthStatus.unauthenticated, busy: true);
    try {
      final user = await ref.read(authRepositoryProvider).register(draft);
      state = AuthState.authenticated(user);
    } on Object catch (error) {
      state = AuthState.unauthenticated(error: _message(error));
    }
  }

  Future<void> enterDemo() async {
    state = AuthState(status: AuthStatus.unauthenticated, busy: true);
    try {
      final user = await ref.read(authRepositoryProvider).enterDemo();
      state = AuthState.authenticated(user);
    } on Object catch (error) {
      state = AuthState.unauthenticated(error: _message(error));
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.unauthenticated();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  }) {
    return ref
        .read(authRepositoryProvider)
        .changePassword(
          currentPassword: currentPassword,
          nextPassword: nextPassword,
        );
  }

  String _message(Object error) => error.toString();
}

final kycControllerProvider = NotifierProvider<KycController, KycState>(
  KycController.new,
);

class KycController extends Notifier<KycState> {
  @override
  KycState build() => const KycState.initial();

  void saveIdentity({required String idType, required String idNumber}) {
    state = state.copyWith(
      identity: KycStepStatus.pending,
      idType: idType,
      idNumber: idNumber,
      sampleDocumentAttached: true,
      note: 'Identity document is pending. It has not been verified.',
    );
  }

  void markSampleSelfie() {
    state = state.copyWith(
      selfie: KycStepStatus.pending,
      sampleSelfieCaptured: true,
      note: 'A sample selfie was captured locally. Liveness verification has not run.',
    );
  }

  void submit() {
    if (!state.sampleDocumentAttached || !state.sampleSelfieCaptured) return;
    state = state.copyWith(
      overall: KycStepStatus.pending,
      note: 'Submitted for review. This demonstration cannot mark an identity as verified.',
    );
  }
}

final notificationProvider =
    NotifierProvider<NotificationController, List<AppNotificationItem>>(
      NotificationController.new,
    );

class NotificationController extends Notifier<List<AppNotificationItem>> {
  @override
  List<AppNotificationItem> build() =>
      List<AppNotificationItem>.of(DemoCatalog.notifications);

  void markRead(String id) {
    state = [
      for (final item in state)
        item.id == id ? item.copyWith(read: true) : item,
    ];
  }
}

final businessesProvider = FutureProvider<List<BusinessOpportunity>>((ref) {
  return ref.watch(businessRepositoryProvider).fetchBusinesses();
});

final campaignProvider = FutureProvider.family<BusinessOpportunity, String>((
  ref,
  id,
) {
  return ref.watch(businessRepositoryProvider).fetchCampaign(id);
});

final portfolioProvider = FutureProvider<List<PortfolioHolding>>((ref) {
  return ref.watch(investmentRepositoryProvider).fetchHoldings();
});

final transactionsProvider = FutureProvider<List<InvestmentTransaction>>((ref) {
  return ref.watch(investmentRepositoryProvider).fetchTransactions();
});

final certificateProvider = FutureProvider.family<PortfolioHolding?, String>((
  ref,
  id,
) {
  return ref.watch(investmentRepositoryProvider).holdingForCertificate(id);
});

final profitProvider = FutureProvider.family<ProfitSnapshot, String>((ref, id) {
  return ref.watch(profitRepositoryProvider).fetchSnapshot(id);
});

final recordsProvider = FutureProvider.family<List<FinancialRecord>, String>((
  ref,
  id,
) {
  return ref.watch(documentRepositoryProvider).fetchRecords(id);
});

final chainEventsProvider = FutureProvider<List<ChainEvent>>((ref) {
  return ref.watch(blockchainRepositoryProvider).fetchEvents();
});

class ReadableDocument {
  const ReadableDocument({
    required this.title,
    required this.status,
    required this.body,
    this.liveTransactionHash,
  });

  final String title;
  final String status;
  final String body;
  final String? liveTransactionHash;
}

final readableDocumentProvider =
    FutureProvider.family<ReadableDocument?, String>((ref, id) async {
      final record = await ref
          .watch(documentRepositoryProvider)
          .fetchRecord(id);
      if (record != null) {
        return ReadableDocument(
          title: record.title,
          status: record.verificationStatus,
          body: record.detail,
          liveTransactionHash: record.hasLiveChainReference
              ? record.liveTransactionHash
              : null,
        );
      }
      final businesses = await ref
          .watch(businessRepositoryProvider)
          .fetchBusinesses();
      for (final business in businesses) {
        for (final document in business.documents) {
          if (document.id == id) {
            return ReadableDocument(
              title: document.title,
              status: document.status,
              body: document.summary,
            );
          }
        }
      }
      return null;
    });

final distributionProvider =
    NotifierProvider<DistributionController, Set<String>>(
      DistributionController.new,
    );

class DistributionController extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void request(String businessId) {
    state = {...state, businessId};
  }
}

final portfolioTotalsProvider = Provider<PortfolioTotals>((ref) {
  final holdings =
      ref.watch(portfolioProvider).asData?.value ?? const <PortfolioHolding>[];
  final businesses =
      ref.watch(businessesProvider).asData?.value ??
      const <BusinessOpportunity>[];
  return PortfolioTotals(holdings: holdings, businesses: businesses);
});

class PortfolioTotals {
  const PortfolioTotals({required this.holdings, required this.businesses});

  final List<PortfolioHolding> holdings;
  final List<BusinessOpportunity> businesses;

  double get invested =>
      holdings.fold(0, (sum, item) => sum + item.amountInvested);
  int get shares => holdings.fold(0, (sum, item) => sum + item.shares);
  int get businessCount => holdings.length;
  int get activeCampaigns => businesses
      .where((item) => item.campaignStatus == CampaignStatus.raising)
      .length;
  double get illustrativeChange =>
      holdings.fold(0, (sum, item) => sum + item.illustrativeValueChange);

  double get zakatableEquity {
    var total = 0.0;
    for (final holding in holdings) {
      final business = _business(holding.businessId);
      if (business == null) continue;
      total += holding.amountInvested * business.zakatableAssetRatio;
    }
    return total;
  }

  BusinessOpportunity? _business(String id) {
    for (final business in businesses) {
      if (business.id == id) return business;
    }
    return null;
  }
}
