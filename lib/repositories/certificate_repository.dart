import '../models/share_certificate.dart';

abstract class CertificateRepository {
  Future<ShareCertificate?> fetchByInvestment(String investmentId);

  Future<ShareCertificate?> fetchByCode(String code);
}
