import 'enums.dart';

/// Local KYC progress for the demo flow. A future Smile ID adapter can
/// replace the service that produces this record.
class KycRecord {
  const KycRecord({
    required this.status,
    required this.idUploaded,
    required this.selfieCaptured,
    this.providerLabel = 'Demo KYC',
  });

  final KycStatus status;
  final bool idUploaded;
  final bool selfieCaptured;
  final String providerLabel;

  KycRecord copyWith({
    KycStatus? status,
    bool? idUploaded,
    bool? selfieCaptured,
  }) {
    return KycRecord(
      status: status ?? this.status,
      idUploaded: idUploaded ?? this.idUploaded,
      selfieCaptured: selfieCaptured ?? this.selfieCaptured,
      providerLabel: providerLabel,
    );
  }
}
