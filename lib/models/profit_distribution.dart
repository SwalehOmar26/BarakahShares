import '../core/utils/finance_calculator.dart';
import 'enums.dart';

class ProfitDistribution {
  const ProfitDistribution({
    required this.id,
    required this.businessId,
    required this.periodLabel,
    required this.grossSalesKes,
    required this.expensesKes,
    required this.ownerPercent,
    required this.investorPoolPercent,
    required this.sharesOwned,
    required this.totalShares,
    required this.status,
  });

  final String id;
  final String businessId;
  final String periodLabel;
  final int grossSalesKes;
  final int expensesKes;
  final double ownerPercent;
  final double investorPoolPercent;
  final int sharesOwned;
  final int totalShares;
  final DistributionStatus status;

  ProfitDistribution copyWith({int? sharesOwned, DistributionStatus? status}) {
    return ProfitDistribution(
      id: id,
      businessId: businessId,
      periodLabel: periodLabel,
      grossSalesKes: grossSalesKes,
      expensesKes: expensesKes,
      ownerPercent: ownerPercent,
      investorPoolPercent: investorPoolPercent,
      sharesOwned: sharesOwned ?? this.sharesOwned,
      totalShares: totalShares,
      status: status ?? this.status,
    );
  }

  int get netProfitKes => grossSalesKes - expensesKes;

  int get ownerShareKes => FinanceCalculator.poolAmount(
    netProfitKes: netProfitKes,
    percent: ownerPercent,
  );

  int get investorPoolKes => FinanceCalculator.poolAmount(
    netProfitKes: netProfitKes,
    percent: investorPoolPercent,
  );

  int get yourDistributionKes => FinanceCalculator.distributionForShares(
    investorPoolKes: investorPoolKes,
    sharesOwned: sharesOwned,
    totalShares: totalShares,
  );
}
