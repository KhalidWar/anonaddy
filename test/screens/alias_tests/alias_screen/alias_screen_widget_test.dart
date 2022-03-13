import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_exports.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/shared_components/shared_components_exports.dart';
import 'package:anonaddy/state_management/alias_state/alias_state_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_data/test_alias_data.dart';
import 'alias_screen_mocks.dart';

/// Widget test for [AliasScreen]
void main() async {
  final testSuccessAlias = Alias.fromJson(testAliasData['data']);
  final testFailedAlias = Alias.fromJson(testErrorAliasData['data']);

  Widget testAliasScreen(
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

  testWidgets(
      'Given AliasScreen is built and no input is given, '
      'When AliasScreenState is in loading state, '
      'Then show loading state UI, no listView, and no error widget.',
      (WidgetTester tester) async {
    // Arrange
    await tester
        .pumpWidget(testAliasScreen(testAliasScreenProvider, testSuccessAlias));

    // Act
    final scaffold = find.byKey(const Key('aliasScreenScaffold'));
    final appBar = find.byType(AppBar);
    final loadingIndicator = find.byType(PlatformLoadingIndicator);
    final lottieWidget = find.byType(LottieWidget);
    final listView = find.byKey(const Key('aliasScreenListView'));

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
        .pumpWidget(testAliasScreen(testAliasScreenProvider, testSuccessAlias));

    /// Updates UI state from loading to loaded.
    await tester.pumpAndSettle();

    // Act
    final scaffold = find.byKey(const Key('aliasScreenScaffold'));
    final appBar = find.byType(AppBar);
    final loadingIndicator = find.byType(PlatformLoadingIndicator);
    final lottieWidget = find.byType(LottieWidget);
    final listView = find.byKey(const Key('aliasScreenListView'));
    final pieChart = find.byType(AliasScreenPieChart);
    final actions = find.text(AppStrings.actions);
    final copyIcon = find.byIcon(Icons.copy);
    final description = find.text(AppStrings.description);
    final defaultRecipients =
        find.byKey(const Key('aliasScreenDefaultRecipient'));
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
        .pumpWidget(testAliasScreen(testAliasScreenProvider, testFailedAlias));

    /// Updates UI state from loading to loaded.
    await tester.pumpAndSettle();

    // Act
    final scaffold = find.byKey(const Key('aliasScreenScaffold'));
    final appBar = find.byType(AppBar);
    final listView = find.byKey(const Key('aliasScreenListView'));
    final lottieWidget = find.byType(LottieWidget);

    // Assert
    expect(scaffold, findsOneWidget);
    expect(appBar, findsOneWidget);
    expect(listView, findsNothing);
    expect(lottieWidget, findsOneWidget);
  });
}
