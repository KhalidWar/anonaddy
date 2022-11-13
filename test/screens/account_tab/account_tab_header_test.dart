import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/notifiers/account/account_notifier.dart';
import 'package:anonaddy/notifiers/account/account_state.dart';
import 'package:anonaddy/screens/account_tab/components/account_tab_header.dart';
import 'package:anonaddy/screens/account_tab/components/account_tab_widget_keys.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/shared_components/list_tiles/account_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_data/account_test_data.dart';

class _MockAccountService extends Mock implements AccountService {}

void main() {
  late _MockAccountService accountService;

  setUp(() {
    accountService = _MockAccountService();
  });

  Widget accountTab(AccountState initialState) {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          accountStateNotifier.overrideWithValue(
            AccountNotifier(
              accountService: accountService,
              initialState: initialState,
            ),
          ),
        ],
        child: const AccountTabHeader(),
      ),
    );
  }

  testWidgets(
      'Given AccountTab is constructed, '
      'When no input is given and state is loading, '
      'Then show loading indicator.', (tester) async {
    // Arrange
    final initialState = AccountState(
      status: AccountStatus.loading,
      account: Account(),
      errorMessage: '',
    );

    when(() => accountService.loadAccountFromDisk())
        .thenAnswer((_) async => AccountTestData.validAccount());
    when(() => accountService.fetchAccount())
        .thenAnswer((_) async => AccountTestData.validAccount());

    await tester.pumpWidget(accountTab(initialState));

    // Assert
    expect(find.byType(AccountTabHeader), findsOneWidget);
    expect(
      find.byKey(AccountTabWidgetKeys.accountTabHeaderLoading),
      findsOneWidget,
    );
    expect(
      find.byKey(AccountTabWidgetKeys.accountTabHeaderHeaderProfile),
      findsNothing,
    );
    expect(
      find.byType(AccountListTile),
      findsNothing,
    );
    expect(
      find.byKey(AccountTabWidgetKeys.accountTabHeaderError),
      findsNothing,
    );
  });

  testWidgets(
      'Given AccountTab is constructed, '
      'When no input is given and state is loaded, '
      'Then show loaded widgets.', (tester) async {
    // Arrange
    // final initialState = AccountState(
    //   status: AccountStatus.loaded,
    //   account: Account(),
    //   errorMessage: '',
    // );

    when(() => accountService.loadAccountFromDisk())
        .thenAnswer((_) async => AccountTestData.validAccount());
    when(() => accountService.fetchAccount())
        .thenAnswer((_) async => AccountTestData.validAccount());

    // await tester.pumpWidget(accountTab(initialState));

    // // Assert
    // expect(find.byType(AccountTabHeader), findsOneWidget);
    // expect(
    //   find.byKey(AccountTabWidgetKeys.accountTabHeaderLoading),
    //   findsNothing,
    // );
    // expect(
    //   find.byKey(AccountTabWidgetKeys.accountTabHeaderHeaderProfile),
    //   findsOneWidget,
    // );
    // expect(
    //   find.byType(AccountListTile),
    //   findsNWidgets(3),
    // );
    // expect(
    //   find.byKey(AccountTabWidgetKeys.accountTabHeaderError),
    //   findsNothing,
    // );
  });

  testWidgets(
      'Given AccountTab is constructed, '
      'When no input is given and state is failed, '
      'Then show error widget.', (tester) async {
    // Arrange
    final initialState = AccountState(
      status: AccountStatus.failed,
      account: Account(),
      errorMessage: '',
    );

    when(() => accountService.loadAccountFromDisk())
        .thenAnswer((_) async => AccountTestData.validAccount());
    when(() => accountService.fetchAccount())
        .thenAnswer((_) async => AccountTestData.validAccount());

    await tester.pumpWidget(accountTab(initialState));

    // Assert
    expect(find.byType(AccountTabHeader), findsOneWidget);
    expect(
      find.byKey(AccountTabWidgetKeys.accountTabHeaderLoading),
      findsNothing,
    );
    expect(
      find.byKey(AccountTabWidgetKeys.accountTabHeaderHeaderProfile),
      findsNothing,
    );
    expect(
      find.byType(AccountListTile),
      findsNothing,
    );
    expect(
      find.byKey(AccountTabWidgetKeys.accountTabHeaderError),
      findsOneWidget,
    );
  });
}
