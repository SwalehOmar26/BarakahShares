import 'enums.dart';

class Receipt {
  const Receipt({
    required this.id,
    required this.businessId,
    required this.title,
    required this.category,
    required this.amountKes,
    required this.date,
    required this.status,
    required this.ipfsCid,
    required this.sha256,
  });

  final String id;
  final String businessId;
  final String title;
  final String category;
  final int amountKes;
  final DateTime date;
  final VerificationStatus status;
  final String ipfsCid;
  final String sha256;

  /// Expense evidence stays off the public chain. Only the fingerprint is shown.
  bool get isPrivateDocument => true;
}

class BusinessDocument {
  const BusinessDocument({
    required this.id,
    required this.businessId,
    required this.title,
    required this.status,
    required this.ipfsCid,
    required this.sha256,
    required this.issuedOn,
  });

  final String id;
  final String businessId;
  final String title;
  final VerificationStatus status;
  final String ipfsCid;
  final String sha256;
  final DateTime issuedOn;

  bool get isPrivateDocument => true;
}
