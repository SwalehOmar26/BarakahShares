import '../../core/utils/finance_calculator.dart';
import '../../models/blockchain_transaction.dart';
import '../../models/enums.dart';
import '../../models/records.dart';
import '../blockchain_service.dart';
import '../document_verification_service.dart';
import '../payment_service.dart';
import '../zakat_service.dart';
import 'demo_database.dart';
import 'mock_seed.dart';

class MockPaymentService implements PaymentService {
  MockPaymentService({this.delay = const Duration(milliseconds: 900)});

  final Duration delay;

  @override
  Future<PaymentResult> requestStkPush({
    required String phone,
    required int amountKes,
    required String businessId,
  }) async {
    await Future<void>.delayed(delay);
    final stamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    return PaymentResult(
      success: true,
      reference: 'DEMO-STK-$stamp',
      txHash: '0x7a3f$stamp',
      network: ChainDemo.network,
      contractShort: ChainDemo.contractShort,
      note: 'Demo Escrow Contract',
    );
  }
}

class MockBlockchainService implements BlockchainService {
  MockBlockchainService(
    this._db, {
    this.delay = const Duration(milliseconds: 180),
  });

  final DemoDatabase _db;
  final Duration delay;

  @override
  String get networkName => ChainDemo.network;

  @override
  String get contractAddress => ChainDemo.contract;

  @override
  String get contractShort => ChainDemo.contractShort;

  @override
  String get statusLabel => ChainDemo.status;

  @override
  bool get isDemoContract => true;

  @override
  Future<List<BlockchainTransaction>> fetchTransactions(
    String businessId,
  ) async {
    await Future<void>.delayed(delay);
    return _db.transactionsFor(businessId);
  }
}

class MockDocumentVerificationService implements DocumentVerificationService {
  MockDocumentVerificationService(this._db);

  final DemoDatabase _db;

  @override
  Future<VerificationResult> verifyReceipt({
    required String receiptId,
    required String sha256,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    final receipt = _db.receiptById(receiptId);
    final matches = receipt != null && receipt.sha256 == sha256;
    return VerificationResult(
      matches: matches,
      status: matches ? VerificationStatus.verified : VerificationStatus.failed,
      message: matches
          ? 'Document fingerprint matches the recorded hash.'
          : 'Document fingerprint does not match the recorded hash.',
    );
  }

  @override
  Future<VerificationResult> verifyDocument({
    required String documentId,
    required String sha256,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    final document = _db.documentById(documentId);
    final matches = document != null && document.sha256 == sha256;
    return VerificationResult(
      matches: matches,
      status: matches ? VerificationStatus.verified : VerificationStatus.failed,
      message: matches
          ? 'Document fingerprint matches the recorded hash.'
          : 'Document fingerprint does not match the recorded hash.',
    );
  }
}

class MockZakatService implements ZakatService {
  const MockZakatService();

  @override
  ZakatEstimate estimate({
    required int portfolioValueKes,
    required int eligibleAssetsKes,
  }) {
    const rate = 0.025;
    return ZakatEstimate(
      portfolioValueKes: portfolioValueKes,
      eligibleAssetsKes: eligibleAssetsKes,
      rate: rate,
      zakatKes: FinanceCalculator.zakatDue(
        eligibleAssetsKes: eligibleAssetsKes,
        rate: rate,
      ),
    );
  }
}
