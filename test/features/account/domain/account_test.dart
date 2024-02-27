import 'package:anonaddy/features/account/domain/account.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_data/account_test_data.dart';

void main() {
  group('Account model testing ', () {
    test('populated constructor', () {
      final account = AccountTestData.validAccount();

      expect(account.id, 'id');
      expect(account.username, 'khalidwar');
      expect(account.subscription, isEmpty);
      expect(account.createdAt, DateTime(2021, 7, 28));
      expect(account.totalEmailsSent, isA<int>());
    });

    test('fromJson() method', () {
      final account = Account.fromJson(
        AccountTestData.validAccountJson['data'],
      );

      expect(account.id, 'id');
      expect(account.username, 'khalidwar');
      expect(account.subscription, 'free');
      expect(account.createdAt, DateTime(2019, 10, 1, 9));
      expect(account.totalEmailsSent, isA<int>());
    });
  });
}
