import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/aliases_tab.dart';
import 'package:anonaddy/features/aliases/presentation/controller/available_aliases_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/deleted_aliases_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks.dart';
import '../../../../test_data/account_test_data.dart';
import '../../../../test_data/alias_test_data.dart';

void main() {
  Widget buildAliasesTab({
    required List<Alias> availableAliases,
    required List<Alias> deletedAliases,
  }) {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          availableAliasesNotifierProvider.overrideWith(() {
            return MockAvailableAliasesNotifier(availableAliases);
          }),
          deletedAliasesNotifierProvider.overrideWith(() {
            return MockDeletedAliasesNotifier(deletedAliases);
          }),
          accountNotifierProvider.overrideWith(() =>
              MockAccountNotifier(account: AccountTestData.validAccount())),
        ],
        child: const AliasesTab(),
      ),
    );
  }

  testWidgets(
    'Given AliasTab is constructed, '
    'When no input and state is loaded, '
    'Then AliasTab widgets load and show list of aliases.',
    (WidgetTester tester) async {
      final availableAlias = AliasTestData.validAliasWithRecipients();
      final deletedAlias =
          AliasTestData.validAliasWithRecipients(isDeleted: true);

      await tester.pumpWidget(buildAliasesTab(
        availableAliases: [availableAlias, availableAlias, availableAlias],
        deletedAliases: [deletedAlias, deletedAlias, deletedAlias],
      ));

      expect(find.byKey(AliasesTab.aliasTabScaffold), findsOneWidget);
      expect(find.byKey(AliasesTab.aliasTabScrollView), findsOneWidget);
      expect(find.byKey(AliasesTab.aliasTabSliverAppBar), findsOneWidget);
      expect(find.byKey(AliasesTab.aliasTabEmailsStats), findsOneWidget);
      expect(find.byKey(AliasesTab.aliasTabTabBar), findsOneWidget);
      expect(
        find.byKey(AliasesTab.aliasTabAvailableAliasesTab),
        findsOneWidget,
      );
      expect(find.byKey(AliasesTab.aliasTabDeletedAliasesTab), findsOneWidget);
      expect(find.byKey(AliasesTab.aliasTabLoadedTabBarView), findsOneWidget);
      expect(
        find.byKey(AliasesTab.aliasTabAvailableAliasesLoading),
        findsNothing,
      );
      expect(
        find.byKey(AliasesTab.aliasTabAvailableAliasListTile),
        findsNWidgets(3),
      );
      expect(find.byKey(AliasesTab.aliasTabDeletedAliasListTile), findsNothing);
    },
  );

  // testWidgets(
  //   'Given AliasTab is constructed, '
  //   'When no input and state is error, '
  //   'Then AliasTab error widget.',
  //   (WidgetTester tester) async {
  //     final availableAlias = AliasTestData.validAliasWithRecipients();
  //     final deletedAlias =
  //         AliasTestData.validAliasWithRecipients(isDeleted: true);
  //
  //     await tester.pumpWidget(buildAliasesTab(
  //       availableAliases: [availableAlias, availableAlias],
  //       deletedAliases: [deletedAlias, deletedAlias],
  //       throwError: true,
  //     ));
  //     await tester.pumpAndSettle();
  //
  //     expect(find.byKey(AliasesTab.aliasTabScaffold), findsOneWidget);
  //     expect(find.byKey(AliasesTab.aliasTabFailedTabBarView), findsOneWidget);
  //     expect(find.byKey(AliasesTab.aliasTabScrollView), findsOneWidget);
  //     expect(
  //       find.byKey(AliasesTab.aliasTabSliverAppBar),
  //       findsOneWidget,
  //     );
  //     expect(
  //       find.byKey(AliasesTab.aliasTabEmailsStats),
  //       findsOneWidget,
  //     );
  //     expect(
  //       find.byKey(AliasesTab.aliasTabTabBar),
  //       findsOneWidget,
  //     );
  //     expect(
  //       find.byKey(AliasesTab.aliasTabAvailableAliasesLoading),
  //       findsNothing,
  //     );
  //     expect(find.byType(ErrorMessageWidget), findsOneWidget);
  //   },
  // );
}
