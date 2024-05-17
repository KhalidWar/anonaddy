import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/components/alias_tab_emails_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks.dart';
import '../../../../test_data/account_test_data.dart';

void main() {
  group('AliasTabEmailsStats testing', () {
    Widget buildAliasesTab(Account account) {
      return MaterialApp(
        home: ProviderScope(
          overrides: [
            accountNotifierProvider
                .overrideWith(() => MockAccountNotifier(account: account)),
          ],
          child: const AliasTabEmailsStats(),
        ),
      );
    }

    testWidgets(
        'Given AliasTabEmailsStats loads, '
        'When account data is provided, '
        'Then show account email stats.', (tester) async {
      final account = AccountTestData.validAccount();

      await tester.pumpWidget(buildAliasesTab(account));
      expect(find.byType(AliasTabEmailsStats), findsOneWidget);
      expect(account.totalEmailsForwarded, 1230);
      expect(account.totalEmailsBlocked, 123);
      expect(account.totalEmailsReplied, 321);
      expect(account.totalEmailsSent, 12);
    });
  });
}
