import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_data/alias_test_data.dart';

void main() {
  group('Alias testing ', () {
    test('default constructor', () async {
      final alias = AliasTestData.validAliasWithRecipients();

      expect(alias, isA<Alias>());
      expect(alias.id, 'fd2258a0-9a40-4825-96c8-ed0f8c38a429');
      expect(alias.email, 'pox.tribute734@laylow.io');
      expect(alias.active, true);
      expect(alias.emailsForwarded, 0);
      expect(alias.recipients, isA<List<Recipient>>());
    });

    test('populated Alias', () async {
      final alias = AliasTestData.validAliasWithRecipients();

      expect(alias, isA<Alias>());
      expect(alias.id, 'fd2258a0-9a40-4825-96c8-ed0f8c38a429');
      expect(alias.email, 'pox.tribute734@laylow.io');
      expect(alias.active, true);
      expect(alias.emailsForwarded, 0);
      expect(alias.recipients.length, 1);
    });

    test('fromJson() method', () async {
      final alias = Alias.fromJson(AliasTestData.validAliasJson['data']);

      expect(alias, isA<Alias>());
      expect(alias.id, 'fd2258a0-9a40-4825-96c8-ed0f8c38a429');
      expect(alias.email, 'pox.tribute734@laylow.io');
      expect(alias.active, true);
      expect(alias.emailsForwarded, 0);
      expect(alias.recipients.length, 1);
    });
  });
}
