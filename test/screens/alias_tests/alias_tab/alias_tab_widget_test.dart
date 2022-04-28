import 'package:anonaddy/screens/alias_tab/alias_tab.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/state_management/alias_state/alias_state_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../alias_screen/alias_screen_mocks.dart';

void main() {
  Widget buildAliasTab() {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          aliasTabStateNotifier.overrideWithProvider(testAliasTabProvider),
        ],
        child: const AliasTab(),
      ),
    );
  }

  testWidgets(
    'Given AliasTab is loaded, '
    'When no input and state is loading, '
    'Then AliasTab widgets load along with loading indicators.',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildAliasTab());

      // Act
      final scaffold = find.byKey(AliasTabWidgetKeys.aliasTabScaffold);
      final scrollView = find.byKey(AliasTabWidgetKeys.aliasTabScrollView);
      final appBar = find.byKey(AliasTabWidgetKeys.aliasTabSliverAppBar);
      final pieChart = find.byKey(AliasTabWidgetKeys.aliasTabPieChart);
      final tapBar = find.byKey(AliasTabWidgetKeys.aliasTabTabBar);
      final availableAliasesTab =
          find.byKey(AliasTabWidgetKeys.aliasTabAvailableAliasesTab);
      final deletedAliasesTab =
          find.byKey(AliasTabWidgetKeys.aliasTabDeletedAliasesTab);
      final tabBarView = find.byKey(AliasTabWidgetKeys.aliasTabTabBarView);
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
}
