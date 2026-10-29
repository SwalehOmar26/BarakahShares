import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../data/demo_catalog.dart';
import '../models/app_user.dart';
import '../storage/secure_store.dart';
import 'demo_delay.dart';

class RegistrationDraft {
  const RegistrationDraft({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    required this.role,
    this.businessName,
  });

  final String fullName;
  final String phone;
  final String email;
  final String password;
  final UserRole role;
  final String? businessName;
}

abstract class AuthRepository {
  Future<AppUser?> currentSession();
  Future<AppUser> login({
    String? phone,
    String? email,
    required String password,
  });
  Future<AppUser> register(RegistrationDraft draft);
  Future<AppUser> enterDemo();
  Future<void> logout();
  Future<String> requestPasswordReset(String phone);
  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  });
}

class _Account {
  _Account({required this.user, required this.password});

  final AppUser user;
  String password;
}

class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._store, {AppUser? initialUser})
    : _current = initialUser;

  final SecureStore _store;
  AppUser? _current;
  final Map<String, _Account> _accounts = {
    AppConstants.demoPhone: _Account(
      user: DemoCatalog.demoUser,
      password: AppConstants.demoPassword,
    ),
  };
  var _accountsLoaded = false;

  Future<void> _loadAccounts() async {
    if (_accountsLoaded) return;
    _accountsLoaded = true;
    try {
      final raw = await _store.read(AppConstants.accountsKey);
      if (raw == null || raw.isEmpty) return;
      final list = jsonDecode(raw) as List<dynamic>;
      for (final item in list) {
        final map = Map<String, dynamic>.from(item as Map);
        final user = AppUser.fromJson(
          Map<String, dynamic>.from(map['user'] as Map),
        );
        final preservedEmail =
            user.email ??
            (user.phone == AppConstants.demoPhone
                ? AppConstants.demoEmail
                : null);
        _accounts[user.phone] = _Account(
          user: preservedEmail == user.email
              ? user
              : AppUser(
                  id: user.id,
                  fullName: user.fullName,
                  phone: user.phone,
                  email: preservedEmail,
                  role: user.role,
                  businessName: user.businessName,
                ),
          password: map['password'] as String? ?? '',
        );
      }
    } on Object {
      // Keep the built-in demonstration account if stored accounts cannot be read.
    }
  }

  Future<void> _persistAccounts() async {
    final payload = _accounts.values
        .map(
          (account) => {
            'user': account.user.toJson(),
            'password': account.password,
          },
        )
        .toList();
    await _store.write(AppConstants.accountsKey, jsonEncode(payload));
  }

  Future<void> _persistSession(AppUser user) async {
    _current = user;
    await _store.write(AppConstants.sessionKey, jsonEncode(user.toJson()));
    await _store.write(AppConstants.tokenKey, 'mock.${user.id}');
  }

  @override
  Future<AppUser?> currentSession() async {
    if (_current != null) return _current;
    try {
      final raw = await _store.read(AppConstants.sessionKey);
      if (raw == null || raw.isEmpty) return null;
      _current = AppUser.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
      return _current;
    } on Object {
      return null;
    }
  }

  @override
  Future<AppUser> login({
    String? phone,
    String? email,
    required String password,
  }) async {
    await demoDelay();
    await _loadAccounts();
    final passwordError = Validators.password(password);
    if (passwordError != null) throw AuthException(passwordError);

    final emailText = email?.trim() ?? '';
    if (emailText.isNotEmpty) {
      final emailError = Validators.email(emailText);
      if (emailError != null) throw AuthException(emailError);
      final normalized = normalizeEmail(emailText);
      final account = _accountForEmail(normalized);
      if (account == null) {
        throw const AuthException(
          'No account found for this email. Register to continue. This demo does not verify email.',
        );
      }
      if (account.password != password) {
        throw const AuthException('Email or password is incorrect.');
      }
      await _persistSession(account.user);
      return account.user;
    }

    final phoneError = Validators.phone(phone);
    if (phoneError != null) throw AuthException(phoneError);
    final normalized = normalizePhone(phone!);
    final account = _accounts[normalized];
    if (account == null) {
      throw const AuthException(
        'No account found for this phone number. Register to continue.',
      );
    }
    if (account.password != password) {
      throw const AuthException('Phone number or password is incorrect.');
    }
    await _persistSession(account.user);
    return account.user;
  }

  _Account? _accountForEmail(String email) {
    for (final account in _accounts.values) {
      final stored = account.user.email;
      if (stored != null && normalizeEmail(stored) == email) return account;
    }
    return null;
  }

  @override
  Future<AppUser> register(RegistrationDraft draft) async {
    await demoDelay();
    await _loadAccounts();
    final phone = normalizePhone(draft.phone);
    final email = normalizeEmail(draft.email);
    final phoneError = Validators.phone(phone);
    final emailError = Validators.email(email);
    final nameError = Validators.personName(draft.fullName);
    final passwordError = Validators.password(draft.password);
    if (nameError != null) throw AuthException(nameError);
    if (phoneError != null) throw AuthException(phoneError);
    if (emailError != null) throw AuthException(emailError);
    if (passwordError != null) throw AuthException(passwordError);
    if (_accounts.containsKey(phone)) {
      throw const AuthException(
        'An account with this phone number already exists. Log in instead.',
      );
    }
    if (_accountForEmail(email) != null) {
      throw const AuthException(
        'An account with this email already exists. Log in instead.',
      );
    }
    final user = AppUser(
      id: 'user-$phone',
      fullName: draft.fullName.trim(),
      phone: phone,
      email: email,
      role: draft.role,
      businessName: draft.businessName?.trim(),
    );
    _accounts[phone] = _Account(user: user, password: draft.password);
    await _persistAccounts();
    await _persistSession(user);
    return user;
  }

  @override
  Future<AppUser> enterDemo() async {
    await demoDelay();
    await _persistSession(DemoCatalog.demoUser);
    return DemoCatalog.demoUser;
  }

  @override
  Future<void> logout() async {
    _current = null;
    await _store.delete(AppConstants.sessionKey);
    await _store.delete(AppConstants.tokenKey);
  }

  @override
  Future<String> requestPasswordReset(String phone) async {
    await demoDelay();
    final error = Validators.phone(phone);
    if (error != null) throw AuthException(error);
    return 'If an account exists for this number, a reset code would be sent by SMS. No message was sent in this demonstration.';
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  }) async {
    await demoDelay();
    await _loadAccounts();
    final user = _current;
    if (user == null) {
      throw const AuthException('Sign in before changing a password.');
    }
    final account = _accounts[user.phone];
    if (account == null || account.password != currentPassword) {
      throw const AuthException('The current password is incorrect.');
    }
    final error = Validators.password(nextPassword);
    if (error != null) throw AuthException(error);
    account.password = nextPassword;
    await _persistAccounts();
  }
}

class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._dio, this._store);

  final Dio _dio;
  final SecureStore _store;

  Future<AppUser> _storeSession(Map<String, dynamic> data) async {
    final token = data['accessToken'];
    final userJson = data['user'];
    if (token is! String || token.isEmpty || userJson is! Map) {
      throw const ApiException(
        'Login response did not include a user and access token.',
      );
    }
    final user = AppUser.fromJson(Map<String, dynamic>.from(userJson));
    await _store.write(AppConstants.tokenKey, token);
    await _store.write(AppConstants.sessionKey, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<AppUser?> currentSession() async {
    final raw = await _store.read(AppConstants.sessionKey);
    if (raw == null || raw.isEmpty) return null;
    return AppUser.fromJson(Map<String, dynamic>.from(jsonDecode(raw) as Map));
  }

  @override
  Future<AppUser> login({
    String? phone,
    String? email,
    required String password,
  }) {
    return guardDio(() async {
      final response = await _dio.post<Object>(
        '/auth/login',
        data: {
          if (phone != null && phone.trim().isNotEmpty)
            'phone': normalizePhone(phone),
          if (email != null && email.trim().isNotEmpty)
            'email': normalizeEmail(email),
          'password': password,
        },
      );
      return _storeSession(expectMap(response.data));
    });
  }

  @override
  Future<AppUser> register(RegistrationDraft draft) {
    return guardDio(() async {
      final response = await _dio.post<Object>(
        '/auth/register',
        data: {
          'fullName': draft.fullName,
          'phone': normalizePhone(draft.phone),
          'email': normalizeEmail(draft.email),
          'password': draft.password,
          'role': draft.role.name,
          'businessName': draft.businessName,
        },
      );
      return _storeSession(expectMap(response.data));
    });
  }

  @override
  Future<AppUser> enterDemo() {
    throw const ApiException(
      'The demonstration sign-in is only available in the mock client.',
    );
  }

  @override
  Future<void> logout() async {
    await _store.delete(AppConstants.sessionKey);
    await _store.delete(AppConstants.tokenKey);
  }

  @override
  Future<String> requestPasswordReset(String phone) {
    return guardDio(() async {
      await _dio.post<Object>(
        '/auth/forgot-password',
        data: {'phone': normalizePhone(phone)},
      );
      return 'If an account exists, the server will send reset instructions.';
    });
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  }) {
    return guardDio(() async {
      await _dio.post<Object>(
        '/auth/change-password',
        data: {
          'currentPassword': currentPassword,
          'nextPassword': nextPassword,
        },
      );
    });
  }
}
