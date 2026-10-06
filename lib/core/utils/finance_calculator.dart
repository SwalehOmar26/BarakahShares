/// Pure investment math used by the UI and unit tests.
abstract final class FinanceCalculator {
  static double ownershipPercent({
    required int investmentKes,
    required int fundingTargetKes,
  }) {
    if (fundingTargetKes <= 0) return 0;
    return investmentKes / fundingTargetKes * 100;
  }

  static int shareCount({
    required int investmentKes,
    required int sharePriceKes,
  }) {
    if (sharePriceKes <= 0) return 0;
    return investmentKes ~/ sharePriceKes;
  }

  static int amountRaised({
    required int filledShares,
    required int sharePriceKes,
  }) {
    return filledShares * sharePriceKes;
  }

  static double campaignProgress({
    required int filledShares,
    required int totalShares,
  }) {
    if (totalShares <= 0) return 0;
    return filledShares / totalShares;
  }

  static int poolAmount({required int netProfitKes, required double percent}) {
    return (netProfitKes * percent / 100).round();
  }

  static int distributionForShares({
    required int investorPoolKes,
    required int sharesOwned,
    required int totalShares,
  }) {
    if (totalShares <= 0 || sharesOwned <= 0) return 0;
    return (investorPoolKes * sharesOwned / totalShares).round();
  }

  static int zakatDue({required int eligibleAssetsKes, double rate = 0.025}) {
    if (eligibleAssetsKes <= 0) return 0;
    return (eligibleAssetsKes * rate).round();
  }
}
