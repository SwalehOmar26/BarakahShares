import '../../models/business.dart';
import '../../models/investment.dart';
import '../../models/profit_distribution.dart';
import '../../models/receipt.dart';
import '../../models/records.dart';
import '../../models/share_certificate.dart';
import '../business_repository.dart';
import '../certificate_repository.dart';
import '../investment_repository.dart';
import '../profit_repository.dart';
import 'demo_database.dart';

class MockBusinessRepository implements BusinessRepository {
  MockBusinessRepository(
    this._db, {
    this.delay = const Duration(milliseconds: 200),
  });

  final DemoDatabase _db;
  final Duration delay;

  @override
  Future<List<Business>> fetchBusinesses() async {
    await Future<void>.delayed(delay);
    return _db.businesses;
  }

  @override
  Future<Business?> fetchBusiness(String id) async {
    await Future<void>.delayed(delay);
    return _db.businessById(id);
  }

  @override
  Future<List<BusinessDocument>> fetchDocuments(String businessId) async {
    await Future<void>.delayed(delay);
    return _db.documentsFor(businessId);
  }

  @override
  Future<List<Receipt>> fetchReceipts(String businessId) async {
    await Future<void>.delayed(delay);
    return _db.receiptsFor(businessId);
  }
}

class MockInvestmentRepository implements InvestmentRepository {
  MockInvestmentRepository(this._db, {this.delay = Duration.zero});

  final DemoDatabase _db;
  final Duration delay;

  @override
  Future<PortfolioSummary> fetchPortfolio(String investorId) async {
    await Future<void>.delayed(delay);
    return _db.portfolioFor(investorId);
  }

  @override
  Future<List<Investment>> fetchInvestments(String investorId) async {
    await Future<void>.delayed(delay);
    return _db.investmentsFor(investorId);
  }

  @override
  Future<Investment?> fetchInvestment(String investmentId) async {
    await Future<void>.delayed(delay);
    return _db.investmentById(investmentId);
  }

  @override
  Future<List<ActivityItem>> fetchActivity() async {
    await Future<void>.delayed(delay);
    return _db.activities();
  }

  @override
  Future<Investment> recordInvestment({
    required String investorId,
    required String investorName,
    required String businessId,
    required int amountKes,
    required String txHash,
  }) {
    return Future<Investment>.value(
      _db.recordInvestment(
        investorId: investorId,
        investorName: investorName,
        businessId: businessId,
        amountKes: amountKes,
        txHash: txHash,
      ),
    );
  }
}

class MockProfitRepository implements ProfitRepository {
  MockProfitRepository(
    this._db, {
    this.delay = const Duration(milliseconds: 200),
  });

  final DemoDatabase _db;
  final Duration delay;

  @override
  Future<ProfitDistribution?> fetchLatest(String businessId) async {
    await Future<void>.delayed(delay);
    return _db.profitFor(businessId);
  }
}

class MockCertificateRepository implements CertificateRepository {
  MockCertificateRepository(
    this._db, {
    this.delay = const Duration(milliseconds: 120),
  });

  final DemoDatabase _db;
  final Duration delay;

  @override
  Future<ShareCertificate?> fetchByInvestment(String investmentId) async {
    await Future<void>.delayed(delay);
    return _db.certificateForInvestment(investmentId);
  }

  @override
  Future<ShareCertificate?> fetchByCode(String code) async {
    await Future<void>.delayed(delay);
    return _db.certificateByCode(code);
  }
}
