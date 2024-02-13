import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/aliases_tab.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_state.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks.dart';
import '../../../../test_data/alias_test_data.dart';

void main() {
  Widget buildAliasesTab(
    AliasesState aliasesState, {
    bool throwError = false,
  }) {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          aliasesNotifierProvider.overrideWith(() {
            return MockAliasesNotifier(
              aliasesState: aliasesState,
              throwError: throwError,
            );
          }),
        ],
        child: const AliasesTab(),
      ),
    );
  }

  testWidgets(
    'Given AliasTab is constructed, '
    'When no input and state is loading, '
    'Then AliasTab widgets load along with loading indicators.',
    (WidgetTester tester) async {
      final availableAlias = AliasTestData.validAliasWithRecipients();
      final deletedAlias =
          availableAlias.copyWith(deletedAt: '2022-02-22 18:08:15');
      final loadingState = AliasesState(
        availableAliases: <Alias>[availableAlias, availableAlias],
        deletedAliases: <Alias>[deletedAlias, deletedAlias],
      );

      // Arrange
      await tester.pumpWidget(buildAliasesTab(loadingState));

      // Act
      final scaffold = find.byKey(AliasesTab.aliasTabScaffold);
      final scrollView = find.byKey(AliasesTab.aliasTabScrollView);
      final appBar = find.byKey(AliasesTab.aliasTabSliverAppBar);
      final pieChart = find.byKey(AliasesTab.aliasTabEmailsStats);
      final tapBar = find.byKey(AliasesTab.aliasTabTabBar);
      final availableAliasesTab =
          find.byKey(AliasesTab.aliasTabAvailableAliasesTab);
      final deletedAliasesTab =
          find.byKey(AliasesTab.aliasTabDeletedAliasesTab);
      final tabBarView = find.byKey(AliasesTab.aliasTabLoadingTabBarView);
      final availableAliasesLoading =
          find.byKey(AliasesTab.aliasTabAvailableAliasesLoading);

      // Assert
      expect(scaffold, findsOneWidget);
      expect(scrollView, findsOneWidget);
      expect(appBar, findsOneWidget);
      expect(pieChart, findsOneWidget);
      expect(tapBar, findsOneWidget);
      expect(availableAliasesTab, findsOneWidget);
      expect(deletedAliasesTab, findsOneWidget);
      expect(tabBarView, findsOneWidget);
      expect(availableAliasesLoading, findsOneWidget);
    },
  );

  testWidgets(
    'Given AliasTab is constructed, '
    'When no input and state is loaded, '
    'Then AliasTab widgets load and show list of aliases.',
    (WidgetTester tester) async {
      final availableAlias = AliasTestData.validAliasWithRecipients();
      final deletedAlias =
          availableAlias.copyWith(deletedAt: '2022-02-22 18:08:15');
      final loadedState = AliasesState(
        availableAliases: <Alias>[
          availableAlias,
          availableAlias,
          availableAlias,
          availableAlias
        ],
        deletedAliases: <Alias>[deletedAlias, deletedAlias],
      );

      // Arrange
      await tester.pumpWidget(buildAliasesTab(loadedState));
      await tester.pumpAndSettle();

      // Act
      final scaffold = find.byKey(AliasesTab.aliasTabScaffold);
      final scrollView = find.byKey(AliasesTab.aliasTabScrollView);
      final appBar = find.byKey(AliasesTab.aliasTabSliverAppBar);
      final pieChart = find.byKey(AliasesTab.aliasTabEmailsStats);
      final tapBar = find.byKey(AliasesTab.aliasTabTabBar);
      final availableAliasesTab =
          find.byKey(AliasesTab.aliasTabAvailableAliasesTab);
      final deletedAliasesTab =
          find.byKey(AliasesTab.aliasTabDeletedAliasesTab);
      final tabBarView = find.byKey(AliasesTab.aliasTabLoadedTabBarView);
      final availableAliasesLoading =
          find.byKey(AliasesTab.aliasTabAvailableAliasesLoading);
      final availableAliases =
          find.byKey(AliasesTab.aliasTabAvailableAliasListTile);
      final deletedAliases =
          find.byKey(AliasesTab.aliasTabDeletedAliasListTile);

      // Assert
      expect(scaffold, findsOneWidget);
      expect(scrollView, findsOneWidget);
      expect(appBar, findsOneWidget);
      expect(pieChart, findsOneWidget);
      expect(tapBar, findsOneWidget);
      expect(availableAliasesTab, findsOneWidget);
      expect(deletedAliasesTab, findsOneWidget);
      expect(tabBarView, findsOneWidget);
      expect(availableAliasesLoading, findsNothing);
      expect(availableAliases, findsNWidgets(4));
      expect(deletedAliases, findsNothing);
    },
  );

  testWidgets(
    'Given AliasTab is constructed, '
    'When no input and state is error, '
    'Then AliasTab error widget.',
    (WidgetTester tester) async {
      final availableAlias = AliasTestData.validAliasWithRecipients();
      final deletedAlias =
          availableAlias.copyWith(deletedAt: '2022-02-22 18:08:15');
      final errorState = AliasesState(
        availableAliases: <Alias>[availableAlias, availableAlias],
        deletedAliases: <Alias>[deletedAlias, deletedAlias],
      );

      // Arrange
      await tester.pumpWidget(buildAliasesTab(errorState, throwError: true));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(AliasesTab.aliasTabScaffold), findsOneWidget);
      expect(find.byKey(AliasesTab.aliasTabFailedTabBarView), findsOneWidget);
      expect(find.byKey(AliasesTab.aliasTabScrollView), findsOneWidget);
      expect(
        find.byKey(AliasesTab.aliasTabSliverAppBar),
        findsOneWidget,
      );
      expect(
        find.byKey(AliasesTab.aliasTabEmailsStats),
        findsOneWidget,
      );
      expect(
        find.byKey(AliasesTab.aliasTabTabBar),
        findsOneWidget,
      );
      expect(
        find.byKey(AliasesTab.aliasTabAvailableAliasesLoading),
        findsNothing,
      );
      expect(find.byType(ErrorMessageWidget), findsOneWidget);
    },
  );
}
