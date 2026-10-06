import '../models/enums.dart';
import '../models/investor.dart';

abstract class AuthService {
  Future<Investor> login({
    required String phone,
    required String password,
    required UserRole role,
  });

  Future<Investor> register({
    required String name,
    required String phone,
    required String password,
    required UserRole role,
  });

  Future<void> logout();

  Future<Investor?> restore();

  Future<Investor> updateInvestor(Investor investor);
}
