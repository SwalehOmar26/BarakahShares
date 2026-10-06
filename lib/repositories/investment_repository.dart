import '../models/investment.dart';
import '../models/records.dart';

abstract class InvestmentRepository {
  Future<PortfolioSummary> fetchPortfolio(String investorId);

  Future<List<Investment>> fetchInvestments(String investorId);

  Future<Investment?> fetchInvestment(String investmentId);

  Future<List<ActivityItem>> fetchActivity();

  Future<Investment> recordInvestment({
    required String investorId,
    required String investorName,
    required String businessId,
    required int amountKes,
    required String txHash,
  });
}
