import '../../core/errors/app_exception.dart';
import '../../core/utils/finance_calculator.dart';
import '../../models/blockchain_transaction.dart';
import '../../models/business.dart';
import '../../models/enums.dart';
import '../../models/investment.dart';
import '../../models/monthly_point.dart';
import '../../models/profit_distribution.dart';
import '../../models/receipt.dart';
import '../../models/records.dart';
import '../../models/share_certificate.dart';
import 'mock_seed.dart';

class DemoDatabase {
  DemoDatabase()
    : _businesses = List.of(MockSeed.businesses()),
      _investments = List.of(MockSeed.investments()),
      _certificates = List.of(MockSeed.certificates()),
      _receipts = List.of(MockSeed.receipts()),
      _documents = List.of(MockSeed.documents()),
      _profits = List.of(MockSeed.profits()),
      _transactions = List.of(MockSeed.transactions()),
      _activities = List.of(MockSeed.activities());

  final List<Business> _businesses;
  final List<Investment> _investments;
  final List<ShareCertificate> _certificates;
  final List<Receipt> _receipts;
  final List<BusinessDocument> _documents;
  final List<ProfitDistribution> _profits;
  final List<BlockchainTransaction> _transactions;
  final List<ActivityItem> _activities;
  int _certificateSerial = 201;

  List<Business> get businesses => List.unmodifiable(_businesses);

  Business? businessById(String id) {
    for (final business in _businesses) {
      if (business.id == id) return business;
    }
    return null;
  }

  List<Investment> investmentsFor(String investorId) {
    return _investments.where((item) => item.investorId == investorId).toList();
  }

  Investment? investmentById(String id) {
    for (final item in _investments) {
      if (item.id == id) return item;
    }
    return null;
  }

  PortfolioSummary portfolioFor(String investorId) {
    final rows = investmentsFor(investorId);
    final invested = rows.fold<int>(0, (sum, item) => sum + item.amountKes);
    final businesses = rows.map((item) => item.businessId).toSet().length;
    return PortfolioSummary(
      totalInvestedKes: invested,
      totalDividendsKes: 4200,
      activeBusinesses: businesses,
      dividendHistory: MockSeed.dividendHistory,
    );
  }

  ShareCertificate? certificateForInvestment(String investmentId) {
    for (final item in _certificates) {
      if (item.investmentId == investmentId) return item;
    }
    return null;
  }

  ShareCertificate? certificateByCode(String code) {
    final normalized = code.trim().toUpperCase();
    for (final item in _certificates) {
      if (item.code.toUpperCase() == normalized) return item;
    }
    return null;
  }

  List<Receipt> receiptsFor(String businessId) {
    return _receipts.where((item) => item.businessId == businessId).toList();
  }

  Receipt? receiptById(String id) {
    for (final item in _receipts) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<BusinessDocument> documentsFor(String businessId) {
    return _documents.where((item) => item.businessId == businessId).toList();
  }

  BusinessDocument? documentById(String id) {
    for (final item in _documents) {
      if (item.id == id) return item;
    }
    return null;
  }

  ProfitDistribution? profitFor(String businessId) {
    for (final item in _profits) {
      if (item.businessId == businessId) return item;
    }
    return null;
  }

  List<BlockchainTransaction> transactionsFor(String businessId) {
    return _transactions
        .where((item) => item.businessId == businessId)
        .toList();
  }

  List<ActivityItem> activities() {
    final copy = List<ActivityItem>.of(_activities);
    copy.sort((a, b) => b.date.compareTo(a.date));
    return copy;
  }

  List<MonthlyPoint> trendFor(String businessId) {
    return businessById(businessId)?.trend ?? const [];
  }

  Investment recordInvestment({
    required String investorId,
    required String investorName,
    required String businessId,
    required int amountKes,
    required String txHash,
  }) {
    final business = businessById(businessId);
    if (business == null) {
      throw const AppException('That business is not available.');
    }
    if (business.campaign.status != CampaignStatus.funding) {
      throw const AppException('This campaign is not open for investment.');
    }
    final shares = FinanceCalculator.shareCount(
      investmentKes: amountKes,
      sharePriceKes: business.campaign.sharePriceKes,
    );
    if (shares < 1) {
      throw const AppException('Enter at least one share.');
    }
    if (shares > business.campaign.availableShares) {
      throw const AppException('Fewer shares are available than that amount.');
    }

    final ownership = FinanceCalculator.ownershipPercent(
      investmentKes: amountKes,
      fundingTargetKes: business.campaign.targetKes,
    );
    final perShare = business.illustrativePerShareKes ?? 0;
    final code =
        'BARAKAH-SHARE-${_certificateSerial.toString().padLeft(4, '0')}';
    _certificateSerial += 1;
    final id = 'inv-${DateTime.now().millisecondsSinceEpoch}';
    final investment = Investment(
      id: id,
      investorId: investorId,
      businessId: business.id,
      businessName: business.name,
      amountKes: amountKes,
      shareCount: shares,
      ownershipPercent: ownership,
      certificateCode: code,
      illustrativeMonthlyKes: perShare * shares,
      investedAt: DateTime.now(),
      status: 'Active',
      txHash: txHash,
    );
    _investments.insert(0, investment);
    _certificates.insert(
      0,
      ShareCertificate(
        code: code,
        investmentId: id,
        investorName: investorName,
        businessId: business.id,
        businessName: business.name,
        investmentKes: amountKes,
        ownershipPercent: ownership,
        issuedAt: DateTime.now(),
        status: 'Verified',
      ),
    );
    _replaceBusiness(
      business.copyWith(
        campaign: business.campaign.copyWith(
          filledShares: business.campaign.filledShares + shares,
        ),
      ),
    );
    final profitIndex = _profits.indexWhere(
      (item) => item.businessId == businessId,
    );
    if (profitIndex >= 0) {
      final current = _profits[profitIndex];
      _profits[profitIndex] = current.copyWith(
        sharesOwned: current.sharesOwned + shares,
      );
    }
    _transactions.insert(
      0,
      BlockchainTransaction(
        id: 'tx-$id',
        businessId: businessId,
        type: ChainTxType.investment,
        title: 'Investment',
        amountKes: amountKes,
        date: DateTime.now(),
        status: 'Confirmed',
        txHash: txHash,
      ),
    );
    _activities.insert(
      0,
      ActivityItem(
        id: 'act-$id',
        kind: ActivityKind.investment,
        title: 'Investment successful',
        subtitle: '${business.name} · recorded in the demo ledger',
        date: DateTime.now(),
        businessId: businessId,
      ),
    );
    _activities.insert(
      0,
      ActivityItem(
        id: 'act-cert-$id',
        kind: ActivityKind.certificate,
        title: 'Certificate issued',
        subtitle: code,
        date: DateTime.now(),
        businessId: businessId,
      ),
    );
    return investment;
  }

  void _replaceBusiness(Business business) {
    final index = _businesses.indexWhere((item) => item.id == business.id);
    if (index >= 0) _businesses[index] = business;
  }
}
