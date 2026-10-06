import '../models/business.dart';
import '../models/receipt.dart';

abstract class BusinessRepository {
  Future<List<Business>> fetchBusinesses();

  Future<Business?> fetchBusiness(String id);

  Future<List<BusinessDocument>> fetchDocuments(String businessId);

  Future<List<Receipt>> fetchReceipts(String businessId);
}
