import '../models/kyc_status.dart';

abstract class KycService {
  /// Demo adapter. A later release can back this with Smile ID.
  Future<KycRecord> statusFor(String userId, {required bool alreadyVerified});

  Future<KycRecord> uploadId(String userId);

  Future<KycRecord> captureSelfie(String userId);

  Future<KycRecord> startVerification(String userId);
}
