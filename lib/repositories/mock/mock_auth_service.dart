import '../../core/constants/demo_account.dart';
import '../../core/errors/app_exception.dart';
import '../../core/services/secure_store.dart';
import '../../core/utils/phone_utils.dart';
import '../../models/enums.dart';
import '../../models/investor.dart';
import '../auth_service.dart';

class _Account {
  _Account({required this.password, required this.investor});

  String password;
  Investor investor;
}

class MockAuthService implements AuthService {
  MockAuthService(
    this._store, {
    this.delay = const Duration(milliseconds: 250),
  }) {
    _accounts[DemoAccount.phone] = _Account(
      password: DemoAccount.password,
      investor: MockAuthService.demoInvestor,
    );
  }

  static const demoInvestor = Investor(
    id: DemoAccount.investorId,
    name: DemoAccount.name,
    phone: DemoAccount.phone,
    role: UserRole.youthInvestor,
    kycStatus: KycStatus.verified,
  );

  final SecureStore _store;
  final Duration delay;
  final Map<String, _Account> _accounts = {};
  static const _sessionKey = 'barakah.session';

  @override
  Future<Investor> login({
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    await Future<void>.delayed(delay);
    final normalized = _phone(phone);
    final account = _accounts[normalized];
    if (account == null || account.password != password) {
      throw const AppException(
        'Those details do not match an account. Demo login is +254700000000 and Demo1234, or create an account.',
      );
    }
    if (password.length < 8) {
      throw const AppException('Password must be at least 8 characters.');
    }
    account.investor = account.investor.copyWith(role: role);
    await _store.write(_sessionKey, account.investor.id);
    return account.investor;
  }

  @override
  Future<Investor> register({
    required String name,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    await Future<void>.delayed(delay);
    final trimmed = name.trim();
    if (trimmed.length < 3) {
      throw const AppException(
        'Enter the name that should appear on your certificate.',
      );
    }
    if (password.length < 8) {
      throw const AppException('Password must be at least 8 characters.');
    }
    final normalized = _phone(phone);
    if (_accounts.containsKey(normalized)) {
      throw const AppException(
        'An account with that phone already exists. Log in instead.',
      );
    }
    final investor = Investor(
      id: 'investor-${normalized.substring(1)}',
      name: trimmed,
      phone: normalized,
      role: role,
      kycStatus: KycStatus.notStarted,
    );
    _accounts[normalized] = _Account(password: password, investor: investor);
    await _store.write(_sessionKey, investor.id);
    return investor;
  }

  @override
  Future<void> logout() async {
    await _store.delete(_sessionKey);
  }

  @override
  Future<Investor?> restore() async {
    final id = await _store.read(_sessionKey);
    if (id == null) return null;
    for (final account in _accounts.values) {
      if (account.investor.id == id) return account.investor;
    }
    return null;
  }

  @override
  Future<Investor> updateInvestor(Investor investor) async {
    for (final account in _accounts.values) {
      if (account.investor.id == investor.id) {
        account.investor = investor;
        return investor;
      }
    }
    throw const AppException('Account not found.');
  }

  String _phone(String input) {
    final phone = normalizeKenyaPhone(input);
    if (phone == null) {
      throw const AppException(
        'Enter a valid Kenyan mobile number, for example 700 000 000.',
      );
    }
    return phone;
  }
}
