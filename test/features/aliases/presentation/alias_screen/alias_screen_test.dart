import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_state.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_screen_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks.dart';
import '../../../../test_data/alias_test_data.dart';

/// Widget test for [AliasScreen]
void main() async {
  group('AliasScreen loading, loaded, and failed states tests', () {
    Widget buildAliasScreen(
      AliasScreenState initialState, {
      bool throwError = false,
    }) {
      return ProviderScope(
        overrides: [
          aliasScreenNotifierProvider.overrideWith(() {
            return MockAliasScreenNotifier(
              aliasScreenState: initialState,
              throwError: throwError,
            );
          }),
        ],
        child: MaterialApp(
          home: AliasScreen(aliasId: initialState.alias.id),
        ),
      );
    }

    testWidgets(
        'Given AliasScreen is built and no input is given, '
        'When AliasScreenState is in loading state, '
        'Then show loading state UI, no listView, and no error widget.',
        (WidgetTester tester) async {
      final loadingState = AliasScreenState(
        alias: AliasTestData.validAliasWithRecipients(),
        isToggleLoading: false,
        deleteAliasLoading: false,
        updateRecipientLoading: false,
        isOffline: false,
      );

      await tester.pumpWidget(buildAliasScreen(loadingState));

      expect(find.byKey(AliasScreen.aliasScreenScaffold), findsOneWidget);
      expect(find.byKey(AliasScreen.aliasScreenAppBar), findsOneWidget);
      expect(
        find.byKey(AliasScreen.aliasScreenLoadingIndicator),
        findsOneWidget,
      );
      expect(find.byKey(AliasScreen.aliasScreenBodyListView), findsNothing);
      expect(
        find.byKey(AliasScreen.aliasScreenLoadingIndicator),
        findsOneWidget,
      );
      expect(find.byKey(AliasScreen.aliasScreenLottieWidget), findsNothing);
    });

    testWidgets(
        'Given AliasScreen is built and no input is given, '
        'When AliasScreenState is in loaded state, '
        'Then show no loading, no error, and all Alias data in listView.',
        (WidgetTester tester) async {
      final loadedState = AliasScreenState(
        // status: AliasScreenStatus.loaded,
        alias: AliasTestData.validAliasWithRecipients(),
        // errorMessage: '',
        isToggleLoading: false,
        deleteAliasLoading: false,
        updateRecipientLoading: false,
        isOffline: false,
      );

      // Arrange
      await tester.pumpWidget(buildAliasScreen(loadedState));
      await tester.pumpAndSettle();

      // Act
      final scaffold = find.byKey(AliasScreen.aliasScreenScaffold);
      final appBar = find.byKey(AliasScreen.aliasScreenAppBar);
      final loadingIndicator =
          find.byKey(AliasScreen.aliasScreenLoadingIndicator);
      final lottieWidget = find.byKey(AliasScreen.aliasScreenLottieWidget);
      final listView = find.byKey(AliasScreen.aliasScreenBodyListView);
      final pieChart = find.byType(AliasScreenPieChart);
      final actions = find.text(AppStrings.actions);
      final copyIcon = find.byIcon(Icons.copy);
      final description = find.text(AppStrings.description);
      final defaultRecipients = find
          .byKey(AliasScreen.aliasScreenDefaultRecipient, skipOffstage: false);
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
      final errorState = AliasScreenState(
        // status: AliasScreenStatus.failed,
        alias: Alias(),
        // errorMessage: AppStrings.somethingWentWrong,
        isToggleLoading: false,
        deleteAliasLoading: false,
        updateRecipientLoading: false,
        isOffline: false,
      );

      // Arrange
      await tester.pumpWidget(buildAliasScreen(errorState));
      await tester.pumpAndSettle();

      // Act
      final scaffold = find.byKey(AliasScreen.aliasScreenScaffold);
      final appBar = find.byKey(AliasScreen.aliasScreenAppBar);
      final listView = find.byKey(AliasScreen.aliasScreenBodyListView);
      final lottieWidget = find.byKey(AliasScreen.aliasScreenLottieWidget);
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
