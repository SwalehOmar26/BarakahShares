class ShareCertificate {
  const ShareCertificate({
    required this.code,
    required this.investmentId,
    required this.investorName,
    required this.businessId,
    required this.businessName,
    required this.investmentKes,
    required this.ownershipPercent,
    required this.issuedAt,
    required this.status,
  });

  final String code;
  final String investmentId;
  final String investorName;
  final String businessId;
  final String businessName;
  final int investmentKes;
  final double ownershipPercent;
  final DateTime issuedAt;
  final String status;

  String get qrPayload => 'barakahshares://certificate/$code';
}
