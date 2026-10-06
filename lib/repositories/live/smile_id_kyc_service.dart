import '../../core/constants/app_env.dart';
import '../../core/errors/app_exception.dart';
import '../../models/kyc_status.dart';
import '../kyc_service.dart';

/// Smile ID adapter. Identity images are not uploaded from this repository.
/// A later SDK integration should capture them on-device and return only a job id.
class SmileIdKycService implements KycService {
  static const sandboxHost = 'https://testapi.smileidentity.com/v1';

  @override
  Future<KycRecord> statusFor(
    String userId, {
    required bool alreadyVerified,
  }) {
    return _blocked();
  }

  @override
  Future<KycRecord> uploadId(String userId) => _blocked();

  @override
  Future<KycRecord> captureSelfie(String userId) => _blocked();

  @override
  Future<KycRecord> startVerification(String userId) => _blocked();

  Future<KycRecord> _blocked() {
    if (!AppEnv.smileReady) {
      throw const AppException('Smile ID is not configured.');
    }
    throw const AppException(
      'Smile ID credentials are present, but this build does not upload an ID or selfie. Use the Smile ID SDK and store only the job result.',
    );
  }
}
