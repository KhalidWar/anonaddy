import 'package:anonaddy/common/list_tiles/account_list_tile.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/components/account_tab_header.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks.dart';
import '../../../test_data/account_test_data.dart';

void main() {
  group('AccountTabHeader testing ', () {
    Widget buildAccountTab(
      Account account, {
      bool throwError = false,
    }) {
      return MaterialApp(
        home: ProviderScope(
          overrides: [
            accountNotifierProvider.overrideWith(
              () => MockAccountNotifier(
                account: account,
                throwError: throwError,
              ),
            ),
          ],
          child: const Scaffold(body: AccountTabHeader()),
        ),
      );
    }

    testWidgets(
        'Given AccountTab is constructed, '
        'When all data is loaded, '
        'Then show header widgets.', (tester) async {
      await tester.pumpWidget(buildAccountTab(AccountTestData.validAccount()));
      await tester.pumpAndSettle();

      expect(find.byType(AccountTabHeader), findsOneWidget);
      expect(
        find.byKey(AccountTabHeader.accountTabHeaderLoading),
        findsNothing,
      );
      expect(
        find.byKey(AccountTabHeader.accountTabHeaderHeaderProfile),
        findsOneWidget,
      );
      expect(find.byType(AccountListTile), findsNWidgets(3));
      expect(
        find.byKey(AccountTabHeader.accountTabHeaderError),
        findsNothing,
      );
    });

    testWidgets(
        'Given AccountTab is constructed, '
        'When state is still loading, '
        'Then show loading indicator.', (tester) async {
      await tester.pumpWidget(buildAccountTab(AccountTestData.validAccount()));

      expect(find.byType(AccountTabHeader), findsOneWidget);
      expect(
        find.byKey(AccountTabHeader.accountTabHeaderLoading),
        findsOneWidget,
      );
      expect(
        find.byKey(AccountTabHeader.accountTabHeaderHeaderProfile),
        findsNothing,
      );
      expect(find.byType(AccountListTile), findsNothing);
      expect(
        find.byKey(AccountTabHeader.accountTabHeaderError),
        findsNothing,
      );
    });

    testWidgets(
        'Given AccountTab is constructed, '
        'When an error occurs, '
        'Then show error widget.', (tester) async {
      await tester.pumpWidget(buildAccountTab(
        AccountTestData.validAccount(),
        throwError: true,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(AccountTabHeader), findsOneWidget);
      expect(
        find.byKey(AccountTabHeader.accountTabHeaderLoading),
        findsNothing,
      );
      expect(
        find.byKey(AccountTabHeader.accountTabHeaderHeaderProfile),
        findsNothing,
      );
      expect(find.byType(AccountListTile), findsNothing);
      expect(
        find.byKey(AccountTabHeader.accountTabHeaderError),
        findsOneWidget,
      );
    });
  });
}
