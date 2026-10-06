class Investment {
  const Investment({
    required this.id,
    required this.investorId,
    required this.businessId,
    required this.businessName,
    required this.amountKes,
    required this.shareCount,
    required this.ownershipPercent,
    required this.certificateCode,
    required this.illustrativeMonthlyKes,
    required this.investedAt,
    required this.status,
    required this.txHash,
  });

  final String id;
  final String investorId;
  final String businessId;
  final String businessName;
  final int amountKes;
  final int shareCount;
  final double ownershipPercent;
  final String certificateCode;
  final int illustrativeMonthlyKes;
  final DateTime investedAt;
  final String status;
  final String txHash;
}

class PortfolioSummary {
  const PortfolioSummary({
    required this.totalInvestedKes,
    required this.totalDividendsKes,
    required this.activeBusinesses,
    required this.dividendHistory,
  });

  final int totalInvestedKes;
  final int totalDividendsKes;
  final int activeBusinesses;
  final List<int> dividendHistory;

  static const historyLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
}
