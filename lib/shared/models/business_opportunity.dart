enum BusinessCategory { restaurants, retail, agriculture, logistics }

enum CampaignStatus { raising, funded, inReview }

class MonthlyFigure {
  const MonthlyFigure({required this.label, required this.profit});

  final String label;
  final double profit;
}

class BusinessDocument {
  const BusinessDocument({
    required this.id,
    required this.businessId,
    required this.title,
    required this.status,
    required this.summary,
  });

  final String id;
  final String businessId;
  final String title;
  final String status;
  final String summary;
}

class BusinessOpportunity {
  const BusinessOpportunity({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.campaignStatus,
    required this.description,
    required this.registrationNumber,
    required this.kraStatus,
    required this.halalStatus,
    required this.historicalMonthlyProfit,
    required this.fundingTarget,
    required this.amountRaised,
    required this.minInvestment,
    required this.pricePerShare,
    required this.ownershipOfferedPercent,
    required this.zakatableAssetRatio,
    required this.risks,
    required this.documents,
    required this.history,
    required this.verificationLabel,
  });

  final String id;
  final String name;
  final String location;
  final BusinessCategory category;
  final CampaignStatus campaignStatus;
  final String description;
  final String registrationNumber;
  final String kraStatus;
  final String halalStatus;
  final double historicalMonthlyProfit;
  final double fundingTarget;
  final double amountRaised;
  final double minInvestment;
  final double pricePerShare;
  final double ownershipOfferedPercent;
  final double zakatableAssetRatio;
  final List<String> risks;
  final List<BusinessDocument> documents;
  final List<MonthlyFigure> history;
  final String verificationLabel;

  double get remainingFunding =>
      (fundingTarget - amountRaised).clamp(0, fundingTarget);

  double get fundingProgress =>
      fundingTarget == 0 ? 0 : (amountRaised / fundingTarget).clamp(0, 1);

  int get sharesOffered =>
      pricePerShare == 0 ? 0 : (fundingTarget / pricePerShare).round();

  bool get canInvest =>
      campaignStatus == CampaignStatus.raising &&
      remainingFunding >= minInvestment;

  String get categoryLabel => switch (category) {
    BusinessCategory.restaurants => 'Restaurants',
    BusinessCategory.retail => 'Retail',
    BusinessCategory.agriculture => 'Agriculture',
    BusinessCategory.logistics => 'Logistics',
  };

  String get statusLabel => switch (campaignStatus) {
    CampaignStatus.raising => 'Raising',
    CampaignStatus.funded => 'Funded',
    CampaignStatus.inReview => 'In review',
  };

  double ownershipForShares(int shares) {
    if (sharesOffered == 0) return 0;
    return shares / sharesOffered * ownershipOfferedPercent;
  }
}
