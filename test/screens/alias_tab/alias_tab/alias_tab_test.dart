import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/aliases_tab.dart';
import 'package:anonaddy/features/aliases/presentation/components/aliases_tab_widget_keys.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_state.dart';
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

  Widget aliasTab(AliasesState aliasTabState) {
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          aliasesNotifierProvider.overrideWith((_) {
            return AliasesNotifier(
              aliasService: mockAliasService,
              initialState: aliasTabState,
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
      const loadingState = AliasesState(
        status: AliasTabStatus.loading,
        errorMessage: '',
        availableAliases: <Alias>[],
        deletedAliases: <Alias>[],
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
      final scaffold = find.byKey(AliasesTabWidgetKeys.aliasTabScaffold);
      final scrollView = find.byKey(AliasesTabWidgetKeys.aliasTabScrollView);
      final appBar = find.byKey(AliasesTabWidgetKeys.aliasTabSliverAppBar);
      final pieChart = find.byKey(AliasesTabWidgetKeys.aliasTabEmailsStats);
      final tapBar = find.byKey(AliasesTabWidgetKeys.aliasTabTabBar);
      final availableAliasesTab =
          find.byKey(AliasesTabWidgetKeys.aliasTabAvailableAliasesTab);
      final deletedAliasesTab =
          find.byKey(AliasesTabWidgetKeys.aliasTabDeletedAliasesTab);
      final tabBarView =
          find.byKey(AliasesTabWidgetKeys.aliasTabLoadingTabBarView);
      final availableAliasesLoading =
          find.byKey(AliasesTabWidgetKeys.aliasTabAvailableAliasesLoading);

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
      const loadedState = AliasesState(
        status: AliasTabStatus.loaded,
        errorMessage: '',
        availableAliases: <Alias>[],
        deletedAliases: <Alias>[],
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
      final scaffold = find.byKey(AliasesTabWidgetKeys.aliasTabScaffold);
      final scrollView = find.byKey(AliasesTabWidgetKeys.aliasTabScrollView);
      final appBar = find.byKey(AliasesTabWidgetKeys.aliasTabSliverAppBar);
      final pieChart = find.byKey(AliasesTabWidgetKeys.aliasTabEmailsStats);
      final tapBar = find.byKey(AliasesTabWidgetKeys.aliasTabTabBar);
      final availableAliasesTab =
          find.byKey(AliasesTabWidgetKeys.aliasTabAvailableAliasesTab);
      final deletedAliasesTab =
          find.byKey(AliasesTabWidgetKeys.aliasTabDeletedAliasesTab);
      final tabBarView =
          find.byKey(AliasesTabWidgetKeys.aliasTabLoadedTabBarView);
      final availableAliasesLoading =
          find.byKey(AliasesTabWidgetKeys.aliasTabAvailableAliasesLoading);
      final availableAliases =
          find.byKey(AliasesTabWidgetKeys.aliasTabAvailableAliasListTile);
      final deletedAliases =
          find.byKey(AliasesTabWidgetKeys.aliasTabDeletedAliasListTile);

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
      const errorState = AliasesState(
        status: AliasTabStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
        availableAliases: <Alias>[],
        deletedAliases: <Alias>[],
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
      expect(find.byKey(AliasesTabWidgetKeys.aliasTabScaffold), findsOneWidget);
      expect(find.byKey(AliasesTabWidgetKeys.aliasTabFailedTabBarView),
          findsOneWidget);
      expect(
          find.byKey(AliasesTabWidgetKeys.aliasTabScrollView), findsOneWidget);
      expect(
        find.byKey(AliasesTabWidgetKeys.aliasTabSliverAppBar),
        findsOneWidget,
      );
      expect(
        find.byKey(AliasesTabWidgetKeys.aliasTabEmailsStats),
        findsOneWidget,
      );
      expect(
        find.byKey(AliasesTabWidgetKeys.aliasTabTabBar),
        findsOneWidget,
      );
      expect(
        find.byKey(AliasesTabWidgetKeys.aliasTabAvailableAliasesLoading),
        findsNothing,
      );
      expect(find.byType(ErrorMessageWidget), findsOneWidget);
    },
  );
}
