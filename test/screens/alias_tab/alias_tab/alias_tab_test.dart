import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_tab.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../alias_tab_mocks.dart';

void main() {
  Widget aliasTab(AliasTabState aliasTabState) {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          aliasTabStateNotifier.overrideWithValue(
            AliasTabNotifier(
              aliasService: MockAliasService(),
              offlineData: MockOfflineData(),
              initialState: aliasTabState,
            ),
          ),
        ],
        child: const AliasTab(),
      ),
    );
  }

  testWidgets(
    'Given AliasTab is constructed, '
    'When no input and state is loading, '
    'Then AliasTab widgets load along with loading indicators.',
    (WidgetTester tester) async {
      final loadingState = AliasTabState(
        status: AliasTabStatus.loading,
        aliases: <Alias>[],
        errorMessage: '',
        availableAliasList: <Alias>[],
        availableListKey: GlobalKey<AnimatedListState>(),
        deletedAliasList: <Alias>[],
      );

      // Arrange
      await tester.pumpWidget(aliasTab(loadingState));

      // Act
      final scaffold = find.byKey(AliasTabWidgetKeys.aliasTabScaffold);
      final scrollView = find.byKey(AliasTabWidgetKeys.aliasTabScrollView);
      final appBar = find.byKey(AliasTabWidgetKeys.aliasTabSliverAppBar);
      final pieChart = find.byKey(AliasTabWidgetKeys.aliasTabEmailsStats);
      final tapBar = find.byKey(AliasTabWidgetKeys.aliasTabTabBar);
      final availableAliasesTab =
          find.byKey(AliasTabWidgetKeys.aliasTabAvailableAliasesTab);
      final deletedAliasesTab =
          find.byKey(AliasTabWidgetKeys.aliasTabDeletedAliasesTab);
      final tabBarView =
          find.byKey(AliasTabWidgetKeys.aliasTabLoadingTabBarView);
      final availableAliasesLoading =
          find.byKey(AliasTabWidgetKeys.aliasTabAvailableAliasesLoading);

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
      final loadedState = AliasTabState(
        status: AliasTabStatus.loaded,
        aliases: <Alias>[],
        errorMessage: '',
        availableAliasList: <Alias>[],
        availableListKey: GlobalKey<AnimatedListState>(),
        deletedAliasList: <Alias>[],
      );

      // Arrange
      await tester.pumpWidget(aliasTab(loadedState));
      await tester.pumpAndSettle();

      // Act
      final scaffold = find.byKey(AliasTabWidgetKeys.aliasTabScaffold);
      final scrollView = find.byKey(AliasTabWidgetKeys.aliasTabScrollView);
      final appBar = find.byKey(AliasTabWidgetKeys.aliasTabSliverAppBar);
      final pieChart = find.byKey(AliasTabWidgetKeys.aliasTabEmailsStats);
      final tapBar = find.byKey(AliasTabWidgetKeys.aliasTabTabBar);
      final availableAliasesTab =
          find.byKey(AliasTabWidgetKeys.aliasTabAvailableAliasesTab);
      final deletedAliasesTab =
          find.byKey(AliasTabWidgetKeys.aliasTabDeletedAliasesTab);
      final tabBarView =
          find.byKey(AliasTabWidgetKeys.aliasTabLoadedTabBarView);
      final availableAliasesLoading =
          find.byKey(AliasTabWidgetKeys.aliasTabAvailableAliasesLoading);
      final availableAliases =
          find.byKey(AliasTabWidgetKeys.aliasTabAvailableAliasListTile);
      final deletedAliases =
          find.byKey(AliasTabWidgetKeys.aliasTabDeletedAliasListTile);

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
      expect(availableAliases, findsNWidgets(1));
      expect(deletedAliases, findsNothing);
    },
  );

  // testWidgets(
  //   'Given AliasTab is constructed, '
  //   'When no input and state is error, '
  //   'Then AliasTab error widget.',
  //   (WidgetTester tester) async {
  //     final errorState = AliasTabState(
  //       status: AliasTabStatus.failed,
  //       errorMessage: AppStrings.somethingWentWrong,
  //       aliases: <Alias>[],
  //       availableListKey: GlobalKey<AnimatedListState>(),
  //       availableAliasList: <Alias>[],
  //       deletedAliasList: <Alias>[],
  //     );
  //
  //     // Arrange
  //     await tester.pumpWidget(aliasTab(errorState));
  //     await tester.pumpAndSettle();
  //
  //     // Act
  //     final scaffold = find.byKey(AliasTabWidgetKeys.aliasTabScaffold);
  //     final scrollView = find.byKey(AliasTabWidgetKeys.aliasTabScrollView);
  //     final appBar = find.byKey(AliasTabWidgetKeys.aliasTabSliverAppBar);
  //     final pieChart = find.byKey(AliasTabWidgetKeys.aliasTabEmailsStats);
  //     final tapBar = find.byKey(AliasTabWidgetKeys.aliasTabTabBar);
  //     final availableAliasesTab =
  //         find.byKey(AliasTabWidgetKeys.aliasTabAvailableAliasesTab);
  //     final deletedAliasesTab =
  //         find.byKey(AliasTabWidgetKeys.aliasTabDeletedAliasesTab);
  //     final tabBarView =
  //         find.byKey(AliasTabWidgetKeys.aliasTabLoadedTabBarView);
  //     final availableAliasesLoading =
  //         find.byKey(AliasTabWidgetKeys.aliasTabAvailableAliasesLoading);
  //     final errorWidget = find.byType(LottieWidget);
  //
  //     // Assert
  //     expect(scaffold, findsOneWidget);
  //     expect(scrollView, findsOneWidget);
  //     expect(appBar, findsOneWidget);
  //     expect(pieChart, findsOneWidget);
  //     expect(tapBar, findsOneWidget);
  //     expect(availableAliasesTab, findsOneWidget);
  //     expect(deletedAliasesTab, findsOneWidget);
  //     expect(tabBarView, findsOneWidget);
  //     expect(availableAliasesLoading, findsNothing);
  //     expect(errorWidget, findsOneWidget);
  //   },
  // );
}
