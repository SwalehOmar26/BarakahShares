import '../core/utils/finance_calculator.dart';
import 'enums.dart';
import 'monthly_point.dart';

class Campaign {
  const Campaign({
    required this.id,
    required this.businessId,
    required this.targetKes,
    required this.sharePriceKes,
    required this.totalShares,
    required this.filledShares,
    required this.equityOfferedPercent,
    required this.investorPoolPercent,
    required this.status,
  });

  final String id;
  final String businessId;
  final int targetKes;
  final int sharePriceKes;
  final int totalShares;
  final int filledShares;
  final double equityOfferedPercent;
  final double investorPoolPercent;
  final CampaignStatus status;

  int get availableShares => (totalShares - filledShares).clamp(0, totalShares);

  Campaign copyWith({int? filledShares, CampaignStatus? status}) {
    return Campaign(
      id: id,
      businessId: businessId,
      targetKes: targetKes,
      sharePriceKes: sharePriceKes,
      totalShares: totalShares,
      filledShares: filledShares ?? this.filledShares,
      equityOfferedPercent: equityOfferedPercent,
      investorPoolPercent: investorPoolPercent,
      status: status ?? this.status,
    );
  }

  int get raisedKes => FinanceCalculator.amountRaised(
    filledShares: filledShares,
    sharePriceKes: sharePriceKes,
  );

  double get progress => FinanceCalculator.campaignProgress(
    filledShares: filledShares,
    totalShares: totalShares,
  );
}

class Business {
  const Business({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.summary,
    required this.overview,
    required this.whyThisBusiness,
    required this.fundingPurpose,
    required this.ownerName,
    required this.ownerVerified,
    required this.monthlyProfitKes,
    required this.campaign,
    required this.shariahApproved,
    required this.audited,
    required this.halalCertified,
    required this.cmaVerified,
    required this.trend,
    required this.artworkKey,
    this.operatingNote,
    this.illustrativePerShareKes,
  });

  final String id;
  final String name;
  final String location;
  final String category;
  final String summary;
  final String overview;
  final String whyThisBusiness;
  final String fundingPurpose;
  final String ownerName;
  final bool ownerVerified;
  final int monthlyProfitKes;
  final Campaign campaign;
  final bool shariahApproved;
  final bool audited;
  final bool halalCertified;
  final bool cmaVerified;
  final List<MonthlyPoint> trend;
  final String artworkKey;
  final String? operatingNote;

  /// Latest illustrative per-share profit distribution, when a period exists.
  final int? illustrativePerShareKes;

  Business copyWith({Campaign? campaign}) {
    return Business(
      id: id,
      name: name,
      location: location,
      category: category,
      summary: summary,
      overview: overview,
      whyThisBusiness: whyThisBusiness,
      fundingPurpose: fundingPurpose,
      ownerName: ownerName,
      ownerVerified: ownerVerified,
      monthlyProfitKes: monthlyProfitKes,
      campaign: campaign ?? this.campaign,
      shariahApproved: shariahApproved,
      audited: audited,
      halalCertified: halalCertified,
      cmaVerified: cmaVerified,
      trend: trend,
      artworkKey: artworkKey,
      operatingNote: operatingNote,
      illustrativePerShareKes: illustrativePerShareKes,
    );
  }
}
