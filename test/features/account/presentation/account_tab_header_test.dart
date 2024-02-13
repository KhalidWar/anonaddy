import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/components/account_tab_header.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/shared_components/list_tiles/account_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks.dart';
import '../../../test_data/account_test_data.dart';

void main() {
  // late MockAccountService accountService;
  late MockAccountNotifier accountNotifier;

  setUp(() {
    // accountService = MockAccountService();
    accountNotifier =
        MockAccountNotifier(account: AccountTestData.defaultAccount());
  });

  Widget buildAccountTab(Account account) {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          accountNotifierProvider.overrideWith(() => accountNotifier),
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
    // final initialState = AccountState(
    //   status: AccountStatus.loading,
    //   account: Account(),
    //   errorMessage: '',
    // );

    // when(() => accountService.loadAccountFromDisk())
    //     .thenAnswer((_) async => AccountTestData.validAccount());
    // when(() => accountService.fetchAccount())
    //     .thenAnswer((_) async => AccountTestData.validAccount());

    await tester.pumpWidget(buildAccountTab(Account()));

    // Assert
    expect(find.byType(AccountTabHeader), findsOneWidget);
    // expect(
    //   find.byKey(AccountTabWidgetKeys.accountTabHeaderLoading),
    //   findsOneWidget,
    // );
    expect(
      find.byKey(AccountTabHeader.accountTabHeaderHeaderProfile),
      findsNothing,
    );
    expect(
      find.byType(AccountListTile),
      findsNothing,
    );
    // expect(
    //   find.byKey(AccountTabWidgetKeys.accountTabHeaderError),
    //   findsNothing,
    // );
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

    // when(() => accountService.loadAccountFromDisk())
    //     .thenAnswer((_) async => AccountTestData.validAccount());
    // when(() => accountService.fetchAccount())
    //     .thenAnswer((_) async => AccountTestData.validAccount());

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
    // final initialState = AccountState(
    //   status: AccountStatus.failed,
    //   account: Account(),
    //   errorMessage: '',
    // );

    // when(() => accountService.loadAccountFromDisk())
    //     .thenAnswer((_) async => AccountTestData.validAccount());
    // when(() => accountService.fetchAccount())
    //     .thenAnswer((_) async => AccountTestData.validAccount());

    await tester.pumpWidget(buildAccountTab(Account()));

    // Assert
    expect(find.byType(AccountTabHeader), findsOneWidget);
    expect(
      find.byKey(AccountTabHeader.accountTabHeaderLoading),
      findsNothing,
    );
    expect(
      find.byKey(AccountTabHeader.accountTabHeaderHeaderProfile),
      findsNothing,
    );
    expect(
      find.byType(AccountListTile),
      findsNothing,
    );
    expect(
      find.byKey(AccountTabHeader.accountTabHeaderError),
      findsOneWidget,
    );
  });
}
