enum KycStepStatus { notStarted, pending, verified, rejected }

class KycState {
  const KycState({
    required this.identity,
    required this.selfie,
    required this.overall,
    this.idType,
    this.idNumber,
    this.sampleDocumentAttached = false,
    this.sampleSelfieCaptured = false,
    this.note = 'Identity has not been submitted.',
  });

  const KycState.initial()
    : identity = KycStepStatus.notStarted,
      selfie = KycStepStatus.notStarted,
      overall = KycStepStatus.notStarted,
      idType = null,
      idNumber = null,
      sampleDocumentAttached = false,
      sampleSelfieCaptured = false,
      note = 'Identity has not been submitted.';

  final KycStepStatus identity;
  final KycStepStatus selfie;
  final KycStepStatus overall;
  final String? idType;
  final String? idNumber;
  final bool sampleDocumentAttached;
  final bool sampleSelfieCaptured;
  final String note;

  String get overallLabel => switch (overall) {
    KycStepStatus.notStarted => 'Not started',
    KycStepStatus.pending => 'Pending',
    KycStepStatus.verified => 'Verified',
    KycStepStatus.rejected => 'Rejected',
  };

  KycState copyWith({
    KycStepStatus? identity,
    KycStepStatus? selfie,
    KycStepStatus? overall,
    String? idType,
    String? idNumber,
    bool? sampleDocumentAttached,
    bool? sampleSelfieCaptured,
    String? note,
  }) {
    return KycState(
      identity: identity ?? this.identity,
      selfie: selfie ?? this.selfie,
      overall: overall ?? this.overall,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      sampleDocumentAttached:
          sampleDocumentAttached ?? this.sampleDocumentAttached,
      sampleSelfieCaptured: sampleSelfieCaptured ?? this.sampleSelfieCaptured,
      note: note ?? this.note,
    );
  }
}
