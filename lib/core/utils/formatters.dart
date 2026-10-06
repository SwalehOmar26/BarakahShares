import 'package:intl/intl.dart';

final _kes = NumberFormat.decimalPattern('en_KE');
final _day = DateFormat('dd MMM yyyy');
final _month = DateFormat('MMM yyyy');

String formatKes(int amount) => 'KES ${_kes.format(amount)}';

String formatPercent(double value, {int digits = 1}) {
  final trimmed = value.toStringAsFixed(digits);
  if (trimmed.endsWith('.0')) {
    return '${trimmed.substring(0, trimmed.length - 2)}%';
  }
  return '$trimmed%';
}

String formatDate(DateTime date) => _day.format(date);

String formatMonth(DateTime date) => _month.format(date);

String truncateMiddle(String value, {int head = 6, int tail = 4}) {
  if (value.length <= head + tail + 1) return value;
  return '${value.substring(0, head)}…${value.substring(value.length - tail)}';
}
