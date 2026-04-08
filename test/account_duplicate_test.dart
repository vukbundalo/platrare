import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/account_lifecycle.dart';
import 'package:platrare/models/account.dart';

void main() {
  group('isAccountDuplicate', () {
    test('allows same name when identifier differs from existing rows', () {
      final accounts = <Account>[
        Account(name: 'Cash', currencyCode: 'BAM'),
        Account(
          name: 'Cash',
          institution: 'Intesa',
          currencyCode: 'BAM',
        ),
      ];
      expect(
        isAccountDuplicate('Cash', null, accounts),
        true,
        reason: 'Cash without id already exists',
      );
      expect(
        isAccountDuplicate('Cash', 'UniCredit', accounts),
        false,
      );
    });

    test('rejects same name and both without identifier', () {
      final a = Account(name: 'Cash', currencyCode: 'BAM');
      final b = Account(name: 'Cash', currencyCode: 'EUR');
      expect(
        isAccountDuplicate('Cash', null, [a, b], exceptAccountId: a.id),
        true,
        reason: 'account b still conflicts',
      );
      expect(
        isAccountDuplicate('Cash', null, [a], exceptAccountId: a.id),
        false,
        reason: 'only row is the one being edited',
      );
      expect(isAccountDuplicate('Cash', null, [a, b]), true);
    });

    test('rejects same name and same identifier (case insensitive)', () {
      final accounts = <Account>[
        Account(
          name: 'Debit',
          institution: 'Intesa Bank',
          currencyCode: 'BAM',
        ),
      ];
      expect(
        isAccountDuplicate('debit', 'intesa bank', accounts),
        true,
      );
    });

    test('allows same identifier when name differs', () {
      final accounts = <Account>[
        Account(
          name: 'Debit',
          institution: 'Intesa',
          currencyCode: 'BAM',
        ),
      ];
      expect(
        isAccountDuplicate('Credit', 'Intesa', accounts),
        false,
      );
    });
  });
}
