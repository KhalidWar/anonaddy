import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/notifiers/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/alias_screen_state.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/screens/alias_tab/components/aliases_tab_widget_keys.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_screen_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks.dart';
import '../../../test_data/alias_test_data.dart';

/// Widget test for [AliasScreen]
void main() async {
  late MockAliasService mockAliasService;
  late MockAliasTabNotifier mockAliasTabNotifier;

  setUp(() {
    mockAliasService = MockAliasService();
    mockAliasTabNotifier = MockAliasTabNotifier();
  });

  group('AliasScreen loading, loaded, and failed states tests', () {
    Widget aliasScreen(AliasScreenState initialState) {
      return ProviderScope(
        overrides: [
          aliasScreenNotifierProvider.overrideWith((_) {
            return AliasScreenNotifier(
              aliasService: mockAliasService,
              aliasTabNotifier: mockAliasTabNotifier,
              initialState: initialState,
            );
          }),
        ],
        child: MaterialApp(
          home: AliasScreen(
            aliasId: AliasTestData.validAliasWithEmptyRecipients(),
          ),
        ),
      );
    }

    testWidgets(
        'Given AliasScreen is built and no input is given, '
        'When AliasScreenState is in loading state, '
        'Then show loading state UI, no listView, and no error widget.',
        (WidgetTester tester) async {
      final loadingState = AliasScreenState(
        status: AliasScreenStatus.loading,
        alias: Alias(),
        errorMessage: '',
        isToggleLoading: false,
        deleteAliasLoading: false,
        updateRecipientLoading: false,
        isOffline: false,
      );

      // when(() => mockAliasService.fetchSpecificAlias(''))
      //     .thenAnswer((_) async => AliasTestData.validAliasWithRecipients());

      // Arrange
      await tester.pumpWidget(aliasScreen(loadingState));

      // Act
      final scaffold = find.byKey(AliasesTabWidgetKeys.aliasScreenScaffold);
      final appBar = find.byKey(AliasesTabWidgetKeys.aliasScreenAppBar);
      final loadingIndicator =
          find.byKey(AliasesTabWidgetKeys.aliasScreenLoadingIndicator);
      final lottieWidget =
          find.byKey(AliasesTabWidgetKeys.aliasScreenLottieWidget);
      final listView = find.byKey(AliasesTabWidgetKeys.aliasScreenBodyListView);
      final loadingWidget =
          find.byKey(AliasesTabWidgetKeys.aliasScreenLoadingIndicator);

      // Assert
      expect(scaffold, findsOneWidget);
      expect(appBar, findsOneWidget);
      expect(loadingIndicator, findsOneWidget);
      expect(listView, findsNothing);
      expect(loadingWidget, findsOneWidget);
      expect(lottieWidget, findsNothing);
    });

    testWidgets(
        'Given AliasScreen is built and no input is given, '
        'When AliasScreenState is in loaded state, '
        'Then show no loading, no error, and all Alias data in listView.',
        (WidgetTester tester) async {
      final loadedState = AliasScreenState(
        status: AliasScreenStatus.loaded,
        alias: AliasTestData.validAliasWithRecipients(),
        errorMessage: '',
        isToggleLoading: false,
        deleteAliasLoading: false,
        updateRecipientLoading: false,
        isOffline: false,
      );

      // Arrange
      await tester.pumpWidget(aliasScreen(loadedState));

      // Act
      final scaffold = find.byKey(AliasesTabWidgetKeys.aliasScreenScaffold);
      final appBar = find.byKey(AliasesTabWidgetKeys.aliasScreenAppBar);
      final loadingIndicator =
          find.byKey(AliasesTabWidgetKeys.aliasScreenLoadingIndicator);
      final lottieWidget =
          find.byKey(AliasesTabWidgetKeys.aliasScreenLottieWidget);
      final listView = find.byKey(AliasesTabWidgetKeys.aliasScreenBodyListView);
      final pieChart = find.byType(AliasScreenPieChart);
      final actions = find.text(AppStrings.actions);
      final copyIcon = find.byIcon(Icons.copy);
      final description = find.text(AppStrings.description);
      final defaultRecipients = find.byKey(
          AliasesTabWidgetKeys.aliasScreenDefaultRecipient,
          skipOffstage: false);
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
        status: AliasScreenStatus.failed,
        alias: Alias(),
        errorMessage: AppStrings.somethingWentWrong,
        isToggleLoading: false,
        deleteAliasLoading: false,
        updateRecipientLoading: false,
        isOffline: false,
      );

      // Arrange
      await tester.pumpWidget(aliasScreen(errorState));

      // Act
      final scaffold = find.byKey(AliasesTabWidgetKeys.aliasScreenScaffold);
      final appBar = find.byKey(AliasesTabWidgetKeys.aliasScreenAppBar);
      final listView = find.byKey(AliasesTabWidgetKeys.aliasScreenBodyListView);
      final lottieWidget =
          find.byKey(AliasesTabWidgetKeys.aliasScreenLottieWidget);
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
