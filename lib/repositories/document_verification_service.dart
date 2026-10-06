import '../models/records.dart';

abstract class DocumentVerificationService {
  Future<VerificationResult> verifyReceipt({
    required String receiptId,
    required String sha256,
  });

  Future<VerificationResult> verifyDocument({
    required String documentId,
    required String sha256,
  });
}
