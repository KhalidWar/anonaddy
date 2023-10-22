import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/notifiers/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/alias_tab_state.dart';
import 'package:anonaddy/screens/alias_tab/alias_tab.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../test_data/alias_test_data.dart';

void main() {
  late MockAliasService mockAliasService;

  setUp(() {
    mockAliasService = MockAliasService();
  });

  Widget aliasTab(AliasTabState aliasTabState) {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          aliasTabStateNotifier.overrideWith((_) {
            return AliasTabNotifier(
              aliasService: mockAliasService,
              initialState: aliasTabState,
            );
          }),
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
      const loadingState = AliasTabState(
        status: AliasTabStatus.loading,
        errorMessage: '',
        availableAliasList: <Alias>[],
        deletedAliasList: <Alias>[],
      );

      final availableAlias = AliasTestData.validAliasWithRecipients();

      when(() => mockAliasService.fetchAvailableAliases()).thenAnswer(
          (_) async => Future.value([availableAlias, availableAlias]));

      when(() => mockAliasService.fetchDeletedAliases()).thenAnswer(
        (_) {
          final deletedAlias =
              availableAlias.copyWith(deletedAt: '2022-02-22 18:08:15');
          return Future.value([deletedAlias, deletedAlias]);
        },
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
      const loadedState = AliasTabState(
        status: AliasTabStatus.loaded,
        errorMessage: '',
        availableAliasList: <Alias>[],
        deletedAliasList: <Alias>[],
      );

      final availableAlias = AliasTestData.validAliasWithRecipients();

      when(() => mockAliasService.fetchAvailableAliases()).thenAnswer(
        (_) async => Future.value(
            [availableAlias, availableAlias, availableAlias, availableAlias]),
      );
      when(() => mockAliasService.fetchDeletedAliases()).thenAnswer(
        (_) async {
          final deletedAlias =
              availableAlias.copyWith(deletedAt: '2022-02-22 18:08:15');
          return [deletedAlias, deletedAlias];
        },
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
      expect(availableAliases, findsNWidgets(4));
      expect(deletedAliases, findsNothing);
    },
  );

  testWidgets(
    'Given AliasTab is constructed, '
    'When no input and state is error, '
    'Then AliasTab error widget.',
    (WidgetTester tester) async {
      const errorState = AliasTabState(
        status: AliasTabStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
        availableAliasList: <Alias>[],
        deletedAliasList: <Alias>[],
      );

      final availableAlias = AliasTestData.validAliasWithRecipients();

      when(() => mockAliasService.fetchAvailableAliases()).thenAnswer(
        (_) async => Future.value([availableAlias, availableAlias]),
      );
      when(() => mockAliasService.fetchDeletedAliases()).thenAnswer(
        (_) async {
          final deletedAlias =
              availableAlias.copyWith(deletedAt: '2022-02-22 18:08:15');
          return [deletedAlias, deletedAlias];
        },
      );

      // Arrange
      await tester.pumpWidget(aliasTab(errorState));

      // Assert
      expect(find.byKey(AliasTabWidgetKeys.aliasTabScaffold), findsOneWidget);
      expect(find.byKey(AliasTabWidgetKeys.aliasTabFailedTabBarView),
          findsOneWidget);
      expect(find.byKey(AliasTabWidgetKeys.aliasTabScrollView), findsOneWidget);
      expect(
        find.byKey(AliasTabWidgetKeys.aliasTabSliverAppBar),
        findsOneWidget,
      );
      expect(
        find.byKey(AliasTabWidgetKeys.aliasTabEmailsStats),
        findsOneWidget,
      );
      expect(
        find.byKey(AliasTabWidgetKeys.aliasTabTabBar),
        findsOneWidget,
      );
      expect(
        find.byKey(AliasTabWidgetKeys.aliasTabAvailableAliasesLoading),
        findsNothing,
      );
      expect(find.byType(ErrorMessageWidget), findsOneWidget);
    },
  );
}
