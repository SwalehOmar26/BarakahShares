class MonthlyPoint {
  const MonthlyPoint({
    required this.label,
    required this.primary,
    this.secondary,
  });

  final String label;
  final int primary;
  final int? secondary;
}
