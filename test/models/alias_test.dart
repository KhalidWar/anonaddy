import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_data/alias_test_data.dart';

void main() {
  group('Alias testing ', () {
    test('default constructor', () async {
      final alias = AliasTestData.defaultAlias();

      expect(alias, isA<Alias>());
      expect(alias.id, isEmpty);
      expect(alias.email, isEmpty);
      expect(alias.active, false);
      expect(alias.emailsForwarded, 0);
      expect(alias.recipients, isEmpty);
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
  });

  group('Alias methods testing ', () {
    test('fromJson()', () async {
      final alias = Alias.fromJson(AliasTestData.validAliasJson['data']);

      expect(alias, isA<Alias>());
      expect(alias.id, 'fd2258a0-9a40-4825-96c8-ed0f8c38a429');
      expect(alias.email, 'pox.tribute734@laylow.io');
      expect(alias.active, true);
      expect(alias.emailsForwarded, 0);
      expect(alias.recipients.length, 1);
    });

    test('copyWith()', () async {
      final alias = AliasTestData.defaultAlias();
      final updatedAlias = alias.copyWith(
        id: 'id',
        email: 'test@example.com',
        active: true,
        emailsForwarded: 42,
      );

      expect(updatedAlias, isA<Alias>());
      expect(updatedAlias.id, 'id');
      expect(updatedAlias.email, 'test@example.com');
      expect(updatedAlias.active, true);
      expect(updatedAlias.emailsForwarded, 42);
    });

    test('toString()', () async {
      final alias = AliasTestData.defaultAlias();
      final stringAlias = alias.toString();

      expect(alias, isA<Alias>());
      expect(stringAlias, isA<String>());
      expect(
        stringAlias,
        "Alias{id: , userId: , aliasableId: , aliasableType: , localPart: , extension: , domain: , email: , active: false, description: , emailsForwarded: 0, emailsBlocked: 0, emailsReplied: 0, emailsSent: 0, recipients: [], createdAt: , updatedAt: , deletedAt: }",
      );
    });
  });
}
