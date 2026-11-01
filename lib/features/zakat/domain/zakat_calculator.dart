class ZakatInput {
  const ZakatInput({
    required this.cashAndBank,
    required this.goldAndSilver,
    required this.tradeGoods,
    required this.receivables,
    required this.zakatableEquity,
    required this.deductions,
    required this.hawlCompleted,
    required this.nisab,
    required this.grossShareValue,
  });

  final double cashAndBank;
  final double goldAndSilver;
  final double tradeGoods;
  final double receivables;

  /// Current-asset portion of long-term partnership holdings.
  /// This is not the full market value of the shares.
  final double zakatableEquity;
  final double deductions;
  final bool hawlCompleted;
  final double nisab;
  final double grossShareValue;

  double get zakatableAssets =>
      cashAndBank + goldAndSilver + tradeGoods + receivables + zakatableEquity;

  double get netZakatable {
    final net = zakatableAssets - deductions;
    return net < 0 ? 0 : net;
  }
}

class ZakatResult {
  const ZakatResult({
    required this.input,
    required this.meetsNisab,
    required this.zakatDue,
    required this.explanation,
  });

  final ZakatInput input;
  final bool meetsNisab;
  final double zakatDue;
  final String explanation;
}

/// Estimates zakat without applying 2.5% to the full value of long-term shares.
ZakatResult calculateZakat(ZakatInput input) {
  final meetsNisab = input.netZakatable >= input.nisab;
  if (!input.hawlCompleted) {
    return ZakatResult(
      input: input,
      meetsNisab: meetsNisab,
      zakatDue: 0,
      explanation:
          'A lunar year (hawl) has not been confirmed, so estimated zakat is KSh 0. '
          'Zakat is not calculated by applying 2.5% to the full share balance of '
          'KSh ${input.grossShareValue.round()}. Long-term partnership holdings contribute '
          'only their illustrative zakatable portion.',
    );
  }
  if (!meetsNisab) {
    return ZakatResult(
      input: input,
      meetsNisab: false,
      zakatDue: 0,
      explanation:
          'Net zakatable wealth is below the illustrative nisab, so estimated zakat is KSh 0. '
          'The full share holding is not treated as cash. Only the zakatable portion of '
          'long-term equity is included, together with cash, trade goods, gold or silver, '
          'and receivables, after deductions.',
    );
  }
  final due = input.netZakatable * 0.025;
  return ZakatResult(
    input: input,
    meetsNisab: true,
    zakatDue: due,
    explanation:
        'Estimated zakat is 2.5% of net zakatable wealth after a lunar year. '
        'Long-term shares are included only through their zakatable portion '
        '(cash, receivables, and trade inventory in the business), not at the full '
        'holding value. This is an educational estimate, not a fatwa.',
  );
}
