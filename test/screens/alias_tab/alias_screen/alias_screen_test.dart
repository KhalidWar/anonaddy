import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_exports.dart';
import 'package:anonaddy/state_management/alias_state/alias_state_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_data/test_alias_data.dart';
import '../alias_tab_mocks.dart';

/// Widget test for [AliasScreen]
void main() async {
  final testSuccessAlias = Alias.fromJson(testAliasData['data']);
  final testFailedAlias = Alias.fromJson(testErrorAliasData['data']);

  Widget aliasScreen(
      AutoDisposeStateNotifierProvider<AliasScreenNotifier, AliasScreenState>
          provider,
      Alias testAlias) {
    return ProviderScope(
      overrides: [
        aliasScreenStateNotifier.overrideWithProvider(provider),
      ],
      child: MaterialApp(
        home: AliasScreen(alias: testAlias),
      ),
    );
  }

  group('AliasScreen loading, loaded, and failed states tests', () {
    testWidgets(
        'Given AliasScreen is built and no input is given, '
        'When AliasScreenState is in loading state, '
        'Then show loading state UI, no listView, and no error widget.',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(aliasScreen(testAliasScreenProvider, testSuccessAlias));

      // Act
      final scaffold = find.byKey(AliasTabWidgetKeys.aliasScreenScaffold);
      final appBar = find.byKey(AliasTabWidgetKeys.aliasScreenAppBar);
      final loadingIndicator =
          find.byKey(AliasTabWidgetKeys.aliasScreenLoadingIndicator);
      final lottieWidget =
          find.byKey(AliasTabWidgetKeys.aliasScreenLottieWidget);
      final listView = find.byKey(AliasTabWidgetKeys.aliasScreenBodyListView);

      // Assert
      expect(scaffold, findsOneWidget);
      expect(appBar, findsOneWidget);
      expect(loadingIndicator, findsOneWidget);
      expect(listView, findsNothing);
      expect(lottieWidget, findsNothing);
    });

    testWidgets(
        'Given AliasScreen is built and no input is given, '
        'When AliasScreenState is in loaded state, '
        'Then show no loading, no error, and all Alias data in listView.',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(aliasScreen(testAliasScreenProvider, testSuccessAlias));

      /// Updates UI state from loading to loaded.
      await tester.pumpAndSettle();

      // Act
      final scaffold = find.byKey(AliasTabWidgetKeys.aliasScreenScaffold);
      final appBar = find.byKey(AliasTabWidgetKeys.aliasScreenAppBar);
      final loadingIndicator =
          find.byKey(AliasTabWidgetKeys.aliasScreenLoadingIndicator);
      final lottieWidget =
          find.byKey(AliasTabWidgetKeys.aliasScreenLottieWidget);
      final listView = find.byKey(AliasTabWidgetKeys.aliasScreenBodyListView);
      final pieChart = find.byType(AliasScreenPieChart);
      final actions = find.text(AppStrings.actions);
      final copyIcon = find.byIcon(Icons.copy);
      final description = find.text(AppStrings.description);
      final defaultRecipients =
          find.byKey(AliasTabWidgetKeys.aliasScreenDefaultRecipient);
      final dividers = find.byType(Divider, skipOffstage: false);

      // Assert
      expect(scaffold, findsOneWidget);
      expect(appBar, findsOneWidget);
      expect(loadingIndicator, findsNothing);
      expect(lottieWidget, findsNothing);
      expect(listView, findsOneWidget);
      expect(pieChart, findsOneWidget);
      expect(actions, findsOneWidget);
      expect(copyIcon, findsOneWidget);
      expect(description, findsOneWidget);
      expect(defaultRecipients, findsOneWidget);
      expect(dividers, findsNWidgets(3));
    });

    testWidgets(
        'Given AliasScreen is built and no input is given, '
        'When AliasScreenState is in error state, '
        'Then show error widget and message.', (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(aliasScreen(testAliasScreenProvider, testFailedAlias));

      /// Updates UI state from loading to loaded.
      await tester.pumpAndSettle();

      // Act
      final scaffold = find.byKey(AliasTabWidgetKeys.aliasScreenScaffold);
      final appBar = find.byKey(AliasTabWidgetKeys.aliasScreenAppBar);
      final listView = find.byKey(AliasTabWidgetKeys.aliasScreenBodyListView);
      final lottieWidget =
          find.byKey(AliasTabWidgetKeys.aliasScreenLottieWidget);
      final errorMessage = find.text(AppStrings.somethingWentWrong);

      // Assert
      expect(scaffold, findsOneWidget);
      expect(appBar, findsOneWidget);
      expect(listView, findsNothing);
      expect(lottieWidget, findsOneWidget);
      expect(errorMessage, findsOneWidget);
    });
  });
}
