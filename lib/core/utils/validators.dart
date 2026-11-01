import 'formatters.dart';

abstract final class Validators {
  static final _phone = RegExp(r'^(?:\+254|254|0)(?:7\d{8}|1\d{8})$');

  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return 'Enter an email address';
    if (!_email.hasMatch(raw)) return 'Enter a valid email address';
    return null;
  }

  static String? phone(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return 'Enter a phone number';
    final compact = raw.replaceAll(RegExp(r'[\s-]'), '');
    if (!_phone.hasMatch(compact)) {
      return 'Enter a valid Kenyan mobile number';
    }
    return null;
  }

  static String? password(String? value) {
    final raw = value ?? '';
    if (raw.length < 8) return 'Use at least 8 characters';
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(raw);
    final hasNumber = RegExp(r'\d').hasMatch(raw);
    if (!hasLetter || !hasNumber) {
      return 'Include at least one letter and one number';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if ((value ?? '').isEmpty) return 'Confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? personName(String? value, {String label = 'full name'}) {
    final raw = value?.trim() ?? '';
    if (raw.length < 2) return 'Enter your $label';
    return null;
  }

  static String? investmentAmount(
    String? value, {
    required double minimum,
    required double remaining,
    required double unitPrice,
  }) {
    final raw = (value ?? '').replaceAll(',', '').trim();
    if (raw.isEmpty) return 'Enter an investment amount';
    final amount = double.tryParse(raw);
    if (amount == null || amount <= 0) {
      return 'Enter a valid amount in shillings';
    }
    if (amount < minimum) return 'Minimum investment is ${formatKes(minimum)}';
    if (amount > remaining) {
      return 'Amount exceeds the remaining ${formatKes(remaining)}';
    }
    if (unitPrice <= 0 || amount % unitPrice != 0) {
      return 'Enter an amount in steps of ${formatKes(unitPrice)}';
    }
    return null;
  }
}
