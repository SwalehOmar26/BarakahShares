import '../models/profit_distribution.dart';

abstract class ProfitRepository {
  Future<ProfitDistribution?> fetchLatest(String businessId);
}
