import 'package:anonaddy/features/account/presentation/account_tab.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks.dart';
import '../../../test_data/account_test_data.dart';

void main() {
  Widget accountTab() {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          accountNotifierProvider.overrideWith(() =>
              MockAccountNotifier(account: AccountTestData.validAccount())),
          recipientsNotifierProvider
              .overrideWith(() => MockRecipientsNotifier(recipients: []))
        ],
        child: const AccountTab(),
      ),
    );
  }

  testWidgets(
    'Given AccountTab is constructed, '
    'When no input is given, '
    'Then load AccountTab',
    (WidgetTester tester) async {
      await tester.pumpWidget(accountTab());
      await tester.pumpAndSettle();

      expect(find.byKey(AccountTab.accountTabScaffold), findsOneWidget);
      expect(find.byKey(AccountTab.accountTabSliverAppBar), findsOneWidget);
    },
  );
}
