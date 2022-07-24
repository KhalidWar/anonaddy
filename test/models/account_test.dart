import 'package:anonaddy/models/account/account.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_data/account_test_data.dart';

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

    test('copyWith()', () {
      final account = AccountTestData.validAccount();

      final updatedAccount = account.copyWith(
        id: 'newId',
        username: 'FlutterTest',
        subscription: 'Pro',
        totalEmailsSent: 99,
      );

      expect(account.id, 'id');
      expect(updatedAccount.id, 'newId');
      expect(account.username, 'khalidwar');
      expect(updatedAccount.username, 'FlutterTest');
      expect(account.subscription, '');
      expect(updatedAccount.subscription, 'Pro');
      expect(account.totalEmailsSent, 0);
      expect(updatedAccount.totalEmailsSent, 99);
    });
  });
}
