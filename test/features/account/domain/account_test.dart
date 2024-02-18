import 'package:anonaddy/features/account/domain/account.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_data/account_test_data.dart';

void main() {
  group('Account model testing ', () {
    test('default constructor', () {
      final account = Account();

      expect(account.id, isEmpty);
      expect(account.username, isEmpty);
      expect(account.subscription, isEmpty);
    });

    test('populated constructor', () {
      final account = AccountTestData.validAccount();

      expect(account.id, 'id');
      expect(account.username, 'khalidwar');
      expect(account.subscription, isEmpty);
      expect(account.createdAt, isNotEmpty);
      expect(account.totalEmailsSent, isA<int>());
    });
  });

  group('Account methods testing ', () {
    test('fromJson()', () {
      final account =
          Account.fromJson(AccountTestData.validAccountJson['data']);

      expect(account.id, 'id');
      expect(account.username, 'khalidwar');
      expect(account.subscription, 'free');
      expect(account.createdAt, isNotEmpty);
      expect(account.totalEmailsSent, isA<int>());
    });
  });
}
