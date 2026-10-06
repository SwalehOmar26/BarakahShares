import '../models/records.dart';

abstract class PaymentService {
  /// Demo adapter. A later release can back this with the Daraja API.
  Future<PaymentResult> requestStkPush({
    required String phone,
    required int amountKes,
    required String businessId,
  });
}
