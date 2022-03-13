import 'package:anonaddy/screens/alias_tab/alias_tab.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildAliasTab() {
    return const MaterialApp(
      home: ProviderScope(
        child: AliasTab(),
      ),
    );
  }

  testWidgets(
      'Given AliasTab is loaded, '
      'When no input, '
      'Then AliasTab widgets load with no error.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildAliasTab());

    // Act
    final scaffold = find.byKey(const Key('aliasTabScaffold'));
    final scrollView = find.byKey(const Key('aliasTabScrollView'));
    final appBar = find.byKey(const Key('aliasTabAppBar'));
    final pieChart = find.byKey(const Key('aliasTabPieChart'));
    final tapBar = find.byKey(const Key('aliasTabTabBar'));
    final tabs = find.byType(Tab);
    final availableTabText = find.text('Available Aliases');
    final deletedTabText = find.text('Deleted Aliases');
    final tabBarView = find.byKey(const Key('aliasTabTabBarView'));
    final aliasShimmerLoading = find.byType(AliasShimmerLoading);
    final availableTab = find.byKey(const Key('aliasTabAvailableAliasesTab'));
    final deletedTab = find.byKey(const Key('aliasTabDeletedAliasesTab'));

    // Assert
    expect(scaffold, findsOneWidget);
    expect(scrollView, findsOneWidget);
    expect(appBar, findsOneWidget);
    expect(pieChart, findsOneWidget);
    expect(tapBar, findsOneWidget);
    expect(tabs, findsNWidgets(2));
    expect(availableTabText, findsOneWidget);
    expect(deletedTabText, findsOneWidget);
    expect(tabBarView, findsOneWidget);
    expect(aliasShimmerLoading, findsOneWidget);
    expect(availableTab, findsOneWidget);
    expect(deletedTab, findsOneWidget);
  });
}
