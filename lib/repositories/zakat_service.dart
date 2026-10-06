import '../models/records.dart';

abstract class ZakatService {
  ZakatEstimate estimate({
    required int portfolioValueKes,
    required int eligibleAssetsKes,
  });
}
