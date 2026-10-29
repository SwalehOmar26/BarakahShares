import 'package:barakah_shares/features/zakat/domain/zakat_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const base = ZakatInput(
    cashAndBank: 0,
    goldAndSilver: 0,
    tradeGoods: 0,
    receivables: 0,
    zakatableEquity: 17250,
    deductions: 0,
    hawlCompleted: true,
    nisab: 1000,
    grossShareValue: 50000,
  );

  test('zakat uses the zakatable equity portion, not the full share value', () {
    final result = calculateZakat(base);
    expect(result.zakatDue, closeTo(17250 * 0.025, 0.001));
    expect(result.zakatDue, isNot(closeTo(50000 * 0.025, 1)));
  });

  test('zakat is zero when the lunar year is not complete', () {
    final result = calculateZakat(
      const ZakatInput(
        cashAndBank: 200000,
        goldAndSilver: 0,
        tradeGoods: 0,
        receivables: 0,
        zakatableEquity: 17250,
        deductions: 0,
        hawlCompleted: false,
        nisab: 95000,
        grossShareValue: 50000,
      ),
    );
    expect(result.zakatDue, 0);
  });

  test('zakat is zero below nisab', () {
    final result = calculateZakat(
      const ZakatInput(
        cashAndBank: 20000,
        goldAndSilver: 0,
        tradeGoods: 0,
        receivables: 8000,
        zakatableEquity: 17250,
        deductions: 6000,
        hawlCompleted: true,
        nisab: 95000,
        grossShareValue: 50000,
      ),
    );
    expect(result.meetsNisab, isFalse);
    expect(result.zakatDue, 0);
  });
}
