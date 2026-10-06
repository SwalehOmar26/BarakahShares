import 'package:barakah_shares/core/utils/finance_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ownership is investment divided by the funding target', () {
    final ownership = FinanceCalculator.ownershipPercent(
      investmentKes: 10000,
      fundingTargetKes: 2000000,
    );
    expect(ownership, 0.5);
  });

  test('share count uses the published share price', () {
    expect(
      FinanceCalculator.shareCount(investmentKes: 20000, sharePriceKes: 10000),
      2,
    );
  });

  test('campaign progress and amount raised follow filled shares', () {
    expect(
      FinanceCalculator.campaignProgress(filledShares: 132, totalShares: 200),
      closeTo(0.66, 0.0001),
    );
    expect(
      FinanceCalculator.amountRaised(filledShares: 132, sharePriceKes: 10000),
      1320000,
    );
  });

  test('investor pool is 40 percent of net profit', () {
    expect(
      FinanceCalculator.poolAmount(netProfitKes: 400000, percent: 40),
      160000,
    );
    expect(
      FinanceCalculator.poolAmount(netProfitKes: 400000, percent: 60),
      240000,
    );
  });

  test('one share of a 200-share pool receives KES 800', () {
    expect(
      FinanceCalculator.distributionForShares(
        investorPoolKes: 160000,
        sharesOwned: 1,
        totalShares: 200,
      ),
      800,
    );
  });

  test('zakat is 2.5 percent of eligible assets', () {
    expect(FinanceCalculator.zakatDue(eligibleAssetsKes: 50000), 1250);
  });
}
