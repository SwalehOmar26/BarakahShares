import 'package:dio/dio.dart';

import '../../core/network/api_exception.dart';
import '../../core/network/dio_client.dart';
import '../data/demo_catalog.dart';
import '../models/records.dart';
import 'demo_delay.dart';

abstract class ProfitRepository {
  Future<ProfitSnapshot> fetchSnapshot(String businessId);
}

abstract class DocumentRepository {
  Future<List<FinancialRecord>> fetchRecords(String businessId);
  Future<FinancialRecord?> fetchRecord(String id);
}

abstract class AiRepository {
  Future<String> ask({
    required String question,
    String? businessId,
    required String userId,
  });
}

abstract class BlockchainRepository {
  Future<List<ChainEvent>> fetchEvents();
}

class MockProfitRepository implements ProfitRepository {
  @override
  Future<ProfitSnapshot> fetchSnapshot(String businessId) async {
    await demoDelay();
    final snapshot = DemoCatalog.profitFor(businessId);
    if (snapshot == null) {
      throw const ApiException(
        'No illustrative profit period is available for this business.',
      );
    }
    return snapshot;
  }
}

class MockDocumentRepository implements DocumentRepository {
  @override
  Future<List<FinancialRecord>> fetchRecords(String businessId) async {
    await demoDelay();
    return DemoCatalog.records
        .where((record) => record.businessId == businessId)
        .toList();
  }

  @override
  Future<FinancialRecord?> fetchRecord(String id) async {
    await demoDelay();
    for (final record in DemoCatalog.records) {
      if (record.id == id) return record;
    }
    return null;
  }
}

class MockAiRepository implements AiRepository {
  @override
  Future<String> ask({
    required String question,
    String? businessId,
    required String userId,
  }) async {
    await demoDelay();
    final business = businessId == null
        ? null
        : DemoCatalog.businessById(businessId);
    final name = business?.name ?? 'this demonstration portfolio';
    final query = question.toLowerCase();
    final profit = business == null ? null : DemoCatalog.profitFor(business.id);
    final caution =
        ' I cannot guarantee a return, approve this contribution, or issue a Shariah ruling.';

    if (query.contains('risk')) {
      final risks =
          business?.risks.join(' ') ??
          'Capital can be lost, the units are illiquid in this demo, and the figures are illustrative.';
      return 'The main risks for $name are: $risks$caution';
    }
    if (query.contains('musharakah')) {
      return 'Musharakah is a partnership in which people contribute capital and share profit by an agreed ratio, while losses follow the capital each person contributed. BarakahShares uses that idea as the educational frame for these campaigns. The screens do not create a legal partnership or a scholar-approved contract.$caution';
    }
    if (query.contains('where') || query.contains('money')) {
      return 'In this demonstration, a contribution toward $name is only recorded inside the app after you explicitly choose a successful mock M-Pesa result. No STK push is sent, and the sample receipts show the kinds of costs a business might record, such as rent, stock, supplies, and licensing.$caution';
    }
    if (query.contains('profit') || query.contains('allocation')) {
      if (profit == null) {
        return 'Open a business first and I can walk through that campaign’s illustrative profit split.$caution';
      }
      return 'For ${profit.periodLabel}, $name shows illustrative gross sales of KSh ${profit.grossSales.round()}, expenses of KSh ${profit.expenses.round()}, and net profit of KSh ${profit.netProfit.round()}. The sample investor allocation is KSh ${profit.investorAllocation.round()}. Distribution status: ${profit.distributionStatus}.$caution';
    }
    if (query.contains('financial') ||
        query.contains('performance') ||
        query.contains('summar')) {
      if (business == null) {
        return 'Choose a business and I can summarise its demonstration figures.$caution';
      }
      return '$name in ${business.location} has an illustrative historical monthly profit of KSh ${business.historicalMonthlyProfit.round()}. The sample round targets KSh ${business.fundingTarget.round()} and shows KSh ${business.amountRaised.round()} raised. These numbers are not audited results.$caution';
    }
    return '$name is presented as a halal-oriented business seeking expansion capital. Review the description, sample documents, funding progress, and risks on the business page before using the mock payment flow.$caution';
  }
}

class MockBlockchainRepository implements BlockchainRepository {
  @override
  Future<List<ChainEvent>> fetchEvents() async {
    await demoDelay();
    return List<ChainEvent>.unmodifiable(DemoCatalog.chainEvents);
  }
}

class RemoteProfitRepository implements ProfitRepository {
  RemoteProfitRepository(this._dio);

  final Dio _dio;

  @override
  Future<ProfitSnapshot> fetchSnapshot(String businessId) {
    return guardDio(() async {
      final response = await _dio.get<Object>('/businesses/$businessId/profit');
      final json = expectMap(response.data);
      return ProfitSnapshot(
        businessId: businessId,
        periodLabel: json['periodLabel'] as String? ?? '',
        grossSales: (json['grossSales'] as num?)?.toDouble() ?? 0,
        expenses: (json['expenses'] as num?)?.toDouble() ?? 0,
        investorAllocation:
            (json['investorAllocation'] as num?)?.toDouble() ?? 0,
        distributionStatus: json['distributionStatus'] as String? ?? 'Unknown',
      );
    });
  }
}

class RemoteDocumentRepository implements DocumentRepository {
  RemoteDocumentRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<FinancialRecord>> fetchRecords(String businessId) {
    return guardDio(() async {
      final response = await _dio.get<Object>(
        '/businesses/$businessId/documents',
      );
      return expectMapList(
        response.data,
        key: 'documents',
      ).map(_record).toList();
    });
  }

  @override
  Future<FinancialRecord?> fetchRecord(String id) {
    return guardDio(() async {
      final response = await _dio.get<Object>('/documents/$id');
      return _record(expectMap(response.data));
    });
  }

  FinancialRecord _record(Map<String, dynamic> json) {
    return FinancialRecord(
      id: json['id'] as String? ?? '',
      businessId: json['businessId'] as String? ?? '',
      kind: json['kind'] == 'income' ? RecordKind.income : RecordKind.expense,
      title: json['title'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      documentType: json['documentType'] as String? ?? '',
      verificationStatus: json['verificationStatus'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      liveTransactionHash: json['transactionHash'] as String?,
    );
  }
}

class RemoteAiRepository implements AiRepository {
  RemoteAiRepository(this._dio);

  final Dio _dio;

  @override
  Future<String> ask({
    required String question,
    String? businessId,
    required String userId,
  }) {
    return guardDio(() async {
      final response = await _dio.post<Object>(
        '/ai/ask',
        data: {
          'question': question,
          'businessId': businessId,
          'userId': userId,
        },
      );
      final data = expectMap(response.data);
      final answer = data['answer'];
      if (answer is! String || answer.trim().isEmpty) {
        throw const ApiException('The assistant response was empty.');
      }
      return answer;
    });
  }
}

class RemoteBlockchainRepository implements BlockchainRepository {
  RemoteBlockchainRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<ChainEvent>> fetchEvents() {
    return guardDio(() async {
      final response = await _dio.get<Object>('/blockchain/events');
      return expectMapList(response.data, key: 'events').map((json) {
        final hash = json['transactionHash'] as String?;
        final live = json['isLive'] == true && hash != null && hash.isNotEmpty;
        return ChainEvent(
          id: json['id'] as String? ?? '',
          title: json['title'] as String? ?? '',
          typeLabel: json['typeLabel'] as String? ?? '',
          date:
              DateTime.tryParse(json['date'] as String? ?? '') ??
              DateTime.now(),
          status: json['status'] as String? ?? '',
          detail: json['detail'] as String? ?? '',
          isLive: live,
          transactionHash: live ? hash : null,
        );
      }).toList();
    });
  }
}
