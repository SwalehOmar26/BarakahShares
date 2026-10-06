import 'enums.dart';

class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.businessId,
  });

  final String id;
  final ActivityKind kind;
  final String title;
  final String subtitle;
  final DateTime date;
  final String businessId;
}

class PaymentResult {
  const PaymentResult({
    required this.success,
    required this.reference,
    required this.txHash,
    required this.network,
    required this.contractShort,
    required this.note,
  });

  final bool success;
  final String reference;
  final String txHash;
  final String network;
  final String contractShort;
  final String note;
}

class VerificationResult {
  const VerificationResult({
    required this.matches,
    required this.message,
    required this.status,
  });

  final bool matches;
  final String message;
  final VerificationStatus status;
}

class ZakatEstimate {
  const ZakatEstimate({
    required this.portfolioValueKes,
    required this.eligibleAssetsKes,
    required this.rate,
    required this.zakatKes,
  });

  final int portfolioValueKes;
  final int eligibleAssetsKes;
  final double rate;
  final int zakatKes;
}

class ContributionRecord {
  const ContributionRecord({
    required this.investmentId,
    required this.businessId,
    required this.businessName,
    required this.amountKes,
    required this.ownershipPercent,
    required this.certificateCode,
    required this.txHash,
    required this.status,
  });

  final String investmentId;
  final String businessId;
  final String businessName;
  final int amountKes;
  final double ownershipPercent;
  final String certificateCode;
  final String txHash;
  final String status;
}
