/// Normalizes Kenyan mobile numbers to E.164 `+2547XXXXXXXX`.
String? normalizeKenyaPhone(String input) {
  final digits = input.replaceAll(RegExp(r'\D'), '');
  String national;
  if (digits.startsWith('254') && digits.length == 12) {
    national = digits.substring(3);
  } else if (digits.startsWith('0') && digits.length == 10) {
    national = digits.substring(1);
  } else if (digits.length == 9) {
    national = digits;
  } else {
    return null;
  }
  if (!RegExp(r'^[17]\d{8}$').hasMatch(national)) return null;
  return '+254$national';
}

String formatKenyaPhone(String e164) {
  final digits = e164.replaceAll(RegExp(r'\D'), '');
  if (digits.length != 12 || !digits.startsWith('254')) return e164;
  final rest = digits.substring(3);
  return '+254 ${rest.substring(0, 3)} ${rest.substring(3, 6)} ${rest.substring(6)}';
}
