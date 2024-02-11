import 'package:anonaddy/features/account/presentation/account_tab.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'account_tab_mocks.dart';

void main() {
  Widget accountTab() {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          accountNotifierProvider
              .overrideWithProvider(testAccountStateNotifier),
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
      // Arrange
      // await tester.pumpWidget(accountTab());
      // await tester.pumpAndSettle();

      // Act
      // final scaffold = find.byKey(AccountTabWidgetKeys.accountTabScaffold);
      // final appBar = find.byKey(AccountTabWidgetKeys.accountTabSliverAppBar);

      // Assert
      // expect(scaffold, findsOneWidget);
      // expect(appBar, findsOneWidget);
    },
  );
}
