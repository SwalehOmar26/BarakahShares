import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../data/demo_catalog.dart';
import '../models/records.dart';
import 'demo_delay.dart';

class ContributionRecorded {
  const ContributionRecorded({
    required this.holding,
    required this.transaction,
  });

  final PortfolioHolding holding;
  final InvestmentTransaction transaction;
}

abstract class InvestmentRepository {
  Future<List<PortfolioHolding>> fetchHoldings();
  Future<List<InvestmentTransaction>> fetchTransactions();
  Future<PortfolioHolding?> holdingForCertificate(String certificateId);
  Future<ContributionRecorded> recordContribution({
    required String businessId,
    required double amount,
    required String phone,
    required String reference,
  });
}

abstract class OwnershipRepository {
  Future<List<OwnershipRecord>> fetchRecords();
}

class MockInvestmentRepository implements InvestmentRepository {
  MockInvestmentRepository({
    List<PortfolioHolding>? holdings,
    List<InvestmentTransaction>? transactions,
  }) : _holdings = List<PortfolioHolding>.of(holdings ?? DemoCatalog.holdings),
       _transactions = List<InvestmentTransaction>.of(
         transactions ?? DemoCatalog.transactions,
       );

  final List<PortfolioHolding> _holdings;
  final List<InvestmentTransaction> _transactions;
  var _sequence = 9000;

  @override
  Future<List<PortfolioHolding>> fetchHoldings() async {
    await demoDelay();
    return List<PortfolioHolding>.unmodifiable(_holdings);
  }

  @override
  Future<List<InvestmentTransaction>> fetchTransactions() async {
    await demoDelay();
    final copy = List<InvestmentTransaction>.of(_transactions);
    copy.sort((a, b) => b.date.compareTo(a.date));
    return List<InvestmentTransaction>.unmodifiable(copy);
  }

  @override
  Future<PortfolioHolding?> holdingForCertificate(String certificateId) async {
    await demoDelay();
    for (final holding in _holdings) {
      if (holding.certificateId == certificateId) return holding;
    }
    return null;
  }

  @override
  Future<ContributionRecorded> recordContribution({
    required String businessId,
    required double amount,
    required String phone,
    required String reference,
  }) async {
    final business = DemoCatalog.businessById(businessId);
    final price = business?.pricePerShare ?? 100;
    final shares = price == 0 ? 0 : (amount / price).round();
    final index = _holdings.indexWhere(
      (holding) => holding.businessId == businessId,
    );
    final now = DateTime.now();
    late final PortfolioHolding holding;
    if (index >= 0) {
      final current = _holdings[index];
      holding = current.copyWith(
        amountInvested: current.amountInvested + amount,
        shares: current.shares + shares,
      );
      _holdings[index] = holding;
    } else {
      _sequence += 1;
      holding = PortfolioHolding(
        businessId: businessId,
        amountInvested: amount,
        shares: shares,
        investedOn: now,
        certificateId: 'BARAKAH-SHARE-${_sequence.toString().padLeft(4, '0')}',
        illustrativeValueChange: 0,
      );
      _holdings.add(holding);
    }
    final transaction = InvestmentTransaction(
      reference: reference,
      businessId: businessId,
      amount: amount,
      shares: shares,
      date: now,
      certificateId: holding.certificateId,
      phone: phone,
      statusLabel: 'Demonstration — mock payment successful',
    );
    _transactions.insert(0, transaction);
    return ContributionRecorded(holding: holding, transaction: transaction);
  }
}

class MockOwnershipRepository implements OwnershipRepository {
  MockOwnershipRepository(this._investments);

  final InvestmentRepository _investments;

  @override
  Future<List<OwnershipRecord>> fetchRecords() async {
    final holdings = await _investments.fetchHoldings();
    return [
      for (final holding in holdings)
        if (DemoCatalog.businessById(holding.businessId) case final business?)
          OwnershipRecord(
            certificateId: holding.certificateId,
            businessId: holding.businessId,
            businessName: business.name,
            shares: holding.shares,
            ownershipPercent: business.ownershipForShares(holding.shares),
            recordedOn: holding.investedOn,
            isLiveChainRecord: false,
          ),
    ];
  }
}

class RemoteInvestmentRepository implements InvestmentRepository {
  RemoteInvestmentRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<PortfolioHolding>> fetchHoldings() {
    return guardDio(() async {
      final response = await _dio.get<Object>('/investments');
      return expectMapList(
        response.data,
        key: 'holdings',
      ).map(_holding).toList();
    });
  }

  @override
  Future<List<InvestmentTransaction>> fetchTransactions() {
    return guardDio(() async {
      final response = await _dio.get<Object>('/investments/transactions');
      return expectMapList(
        response.data,
        key: 'transactions',
      ).map(_transaction).toList();
    });
  }

  @override
  Future<PortfolioHolding?> holdingForCertificate(String certificateId) async {
    final holdings = await fetchHoldings();
    for (final holding in holdings) {
      if (holding.certificateId == certificateId) return holding;
    }
    return null;
  }

  @override
  Future<ContributionRecorded> recordContribution({
    required String businessId,
    required double amount,
    required String phone,
    required String reference,
  }) {
    return guardDio(() async {
      final response = await _dio.post<Object>(
        '/investments',
        data: {
          'businessId': businessId,
          'amount': amount,
          'phone': phone,
          'reference': reference,
        },
      );
      final data = expectMap(response.data);
      final holding = _holding(expectMap(data['holding']));
      final transaction = _transaction(expectMap(data['transaction']));
      return ContributionRecorded(holding: holding, transaction: transaction);
    });
  }

  PortfolioHolding _holding(Map<String, dynamic> json) {
    return PortfolioHolding(
      businessId: json['businessId'] as String? ?? '',
      amountInvested: (json['amountInvested'] as num?)?.toDouble() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      investedOn:
          DateTime.tryParse(json['investedOn'] as String? ?? '') ??
          DateTime.now(),
      certificateId: json['certificateId'] as String? ?? '',
      illustrativeValueChange:
          (json['illustrativeValueChange'] as num?)?.toDouble() ?? 0,
    );
  }

  InvestmentTransaction _transaction(Map<String, dynamic> json) {
    return InvestmentTransaction(
      reference: json['reference'] as String? ?? '',
      businessId: json['businessId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      certificateId: json['certificateId'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      statusLabel: json['statusLabel'] as String? ?? '',
    );
  }
}

class RemoteOwnershipRepository implements OwnershipRepository {
  RemoteOwnershipRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<OwnershipRecord>> fetchRecords() {
    return guardDio(() async {
      final response = await _dio.get<Object>('/ownership');
      return expectMapList(response.data, key: 'records').map((json) {
        return OwnershipRecord(
          certificateId: json['certificateId'] as String? ?? '',
          businessId: json['businessId'] as String? ?? '',
          businessName: json['businessName'] as String? ?? '',
          shares: (json['shares'] as num?)?.toInt() ?? 0,
          ownershipPercent: (json['ownershipPercent'] as num?)?.toDouble() ?? 0,
          recordedOn:
              DateTime.tryParse(json['recordedOn'] as String? ?? '') ??
              DateTime.now(),
          isLiveChainRecord: json['isLiveChainRecord'] == true,
        );
      }).toList();
    });
  }
}
