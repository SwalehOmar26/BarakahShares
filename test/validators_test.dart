import 'package:barakah_shares/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts Kenyan mobile numbers', () {
    expect(Validators.phone('0712345678'), isNull);
    expect(Validators.phone('+254712345678'), isNull);
    expect(Validators.phone('12345'), isNotNull);
  });

  test('accepts a normal email address', () {
    expect(Validators.email('amina@barakahshares.app'), isNull);
    expect(Validators.email('not-an-email'), 'Enter a valid email address');
    expect(Validators.email('  '), 'Enter an email address');
  });

  test('requires a letter and a number in the password', () {
    expect(Validators.password('short'), isNotNull);
    expect(Validators.password('longpassword'), isNotNull);
    expect(Validators.password('Barakah1'), isNull);
  });

  test('requires matching password confirmation', () {
    expect(Validators.confirmPassword('Barakah1', 'Barakah1'), isNull);
    expect(
      Validators.confirmPassword('Barakah2', 'Barakah1'),
      'Passwords do not match',
    );
    expect(Validators.confirmPassword('', 'Barakah1'), 'Confirm your password');
  });

  test(
    'rejects an investment below the minimum or above the remaining target',
    () {
      expect(
        Validators.investmentAmount(
          '1000',
          minimum: 5000,
          remaining: 750000,
          unitPrice: 100,
        ),
        contains('Minimum'),
      );
      expect(
        Validators.investmentAmount(
          '900000',
          minimum: 5000,
          remaining: 750000,
          unitPrice: 100,
        ),
        contains('exceeds'),
      );
      expect(
        Validators.investmentAmount(
          '5000',
          minimum: 5000,
          remaining: 750000,
          unitPrice: 100,
        ),
        isNull,
      );
    },
  );
}
