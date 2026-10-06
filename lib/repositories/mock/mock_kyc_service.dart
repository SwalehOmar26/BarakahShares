import '../../models/enums.dart';
import '../../models/kyc_status.dart';
import '../kyc_service.dart';

class MockKycService implements KycService {
  MockKycService({this.delay = const Duration(milliseconds: 350)});

  final Duration delay;
  final Map<String, KycRecord> _records = {};

  @override
  Future<KycRecord> statusFor(
    String userId, {
    required bool alreadyVerified,
  }) async {
    return _records.putIfAbsent(
      userId,
      () => KycRecord(
        status: alreadyVerified ? KycStatus.verified : KycStatus.notStarted,
        idUploaded: alreadyVerified,
        selfieCaptured: alreadyVerified,
      ),
    );
  }

  @override
  Future<KycRecord> uploadId(String userId) async {
    await Future<void>.delayed(delay);
    final current = await statusFor(userId, alreadyVerified: false);
    final next = current.copyWith(idUploaded: true, status: KycStatus.pending);
    _records[userId] = next;
    return next;
  }

  @override
  Future<KycRecord> captureSelfie(String userId) async {
    await Future<void>.delayed(delay);
    final current = await statusFor(userId, alreadyVerified: false);
    if (!current.idUploaded) {
      final waiting = current.copyWith(status: KycStatus.pending);
      _records[userId] = waiting;
      return waiting;
    }
    final next = current.copyWith(
      selfieCaptured: true,
      status: KycStatus.pending,
    );
    _records[userId] = next;
    return next;
  }

  @override
  Future<KycRecord> startVerification(String userId) async {
    await Future<void>.delayed(delay);
    final current = await statusFor(userId, alreadyVerified: false);
    if (!current.idUploaded || !current.selfieCaptured) {
      final pending = current.copyWith(status: KycStatus.pending);
      _records[userId] = pending;
      return pending;
    }
    final verified = current.copyWith(status: KycStatus.verified);
    _records[userId] = verified;
    return verified;
  }
}
