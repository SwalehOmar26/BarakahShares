import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../models/records.dart';
import 'demo_delay.dart';
import 'investment_repository.dart';

abstract class PaymentRepository {
  Future<PaymentAttempt> complete({
    required PaymentOutcome outcome,
    required String businessId,
    required double amount,
    required String phone,
  });

  PaymentAttempt? find(String reference);
}

class MockPaymentRepository implements PaymentRepository {
  MockPaymentRepository(this._investments);

  final InvestmentRepository _investments;
  final Map<String, PaymentAttempt> _attempts = {};

  @override
  Future<PaymentAttempt> complete({
    required PaymentOutcome outcome,
    required String businessId,
    required double amount,
    required String phone,
  }) async {
    await demoDelay();
    final reference = 'DEMO-${DateTime.now().millisecondsSinceEpoch}';
    if (outcome != PaymentOutcome.successful) {
      final attempt = PaymentAttempt(
        reference: reference,
        outcome: outcome,
        businessId: businessId,
        amount: amount,
        phone: phone,
        shares: 0,
        certificateId: null,
        createdAt: DateTime.now(),
      );
      _attempts[reference] = attempt;
      return attempt;
    }
    final recorded = await _investments.recordContribution(
      businessId: businessId,
      amount: amount,
      phone: phone,
      reference: reference,
    );
    final attempt = PaymentAttempt(
      reference: recorded.transaction.reference,
      outcome: PaymentOutcome.successful,
      businessId: businessId,
      amount: amount,
      phone: phone,
      shares: recorded.transaction.shares,
      certificateId: recorded.holding.certificateId,
      createdAt: recorded.transaction.date,
    );
    _attempts[attempt.reference] = attempt;
    return attempt;
  }

  @override
  PaymentAttempt? find(String reference) => _attempts[reference];
}

class RemotePaymentRepository implements PaymentRepository {
  RemotePaymentRepository(this._dio);

  final Dio _dio;
  final Map<String, PaymentAttempt> _cache = {};

  @override
  Future<PaymentAttempt> complete({
    required PaymentOutcome outcome,
    required String businessId,
    required double amount,
    required String phone,
  }) {
    return guardDio(() async {
      final response = await _dio.post<Object>(
        '/payments',
        data: {
          'outcome': outcome.name,
          'businessId': businessId,
          'amount': amount,
          'phone': phone,
        },
      );
      final attempt = _fromJson(expectMap(response.data));
      _cache[attempt.reference] = attempt;
      return attempt;
    });
  }

  @override
  PaymentAttempt? find(String reference) => _cache[reference];

  PaymentAttempt _fromJson(Map<String, dynamic> json) {
    return PaymentAttempt(
      reference: json['reference'] as String? ?? '',
      outcome: PaymentOutcome.values.firstWhere(
        (item) => item.name == json['outcome'],
        orElse: () => PaymentOutcome.pending,
      ),
      businessId: json['businessId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      phone: json['phone'] as String? ?? '',
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      certificateId: json['certificateId'] as String?,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
