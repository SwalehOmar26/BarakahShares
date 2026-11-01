const _months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatKes(num value, {bool decimals = false}) {
  final sign = value < 0 ? '-' : '';
  final absolute = value.abs();
  final fixed = decimals
      ? absolute.toStringAsFixed(2)
      : absolute.round().toString();
  final parts = fixed.split('.');
  final digits = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    final remaining = digits.length - index;
    if (index > 0 && remaining % 3 == 0) buffer.write(',');
    buffer.write(digits[index]);
  }
  final fraction = parts.length > 1 ? '.${parts[1]}' : '';
  return '${sign}KSh $buffer$fraction';
}

String formatDate(DateTime date) {
  return '${date.day} ${_months[date.month - 1]} ${date.year}';
}

String formatPercent(double fraction) {
  final percent = fraction * 100;
  if (percent == 0) return '0%';
  if (percent.abs() < 0.1) return '${percent.toStringAsFixed(2)}%';
  if (percent.abs() < 10) {
    final rounded = (percent * 10).round() / 10;
    if (rounded == rounded.roundToDouble()) return '${rounded.toInt()}%';
    return '${rounded.toStringAsFixed(1)}%';
  }
  return '${percent.round()}%';
}

String formatRatio(double part, double whole) {
  if (whole == 0) return '0%';
  return formatPercent(part / whole);
}

String greetingFor(DateTime time) {
  if (time.hour < 12) return 'Good morning';
  if (time.hour < 17) return 'Good afternoon';
  return 'Good evening';
}

String normalizeEmail(String input) => input.trim().toLowerCase();

String normalizePhone(String input) {
  final compact = input.replaceAll(RegExp(r'[\s-]'), '');
  if (compact.startsWith('+254') && compact.length > 4) {
    return '0${compact.substring(4)}';
  }
  if (compact.startsWith('254') && compact.length > 3) {
    return '0${compact.substring(3)}';
  }
  return compact;
}

String displayPhone(String phone) {
  final normalized = normalizePhone(phone);
  if (normalized.length != 10) return phone;
  return '${normalized.substring(0, 4)} ${normalized.substring(4, 7)} ${normalized.substring(7)}';
}
