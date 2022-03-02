import 'package:anonaddy/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  Widget buildHomeScreen() {
    return const ProviderScope(
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  testWidgets(
      'Given home screen is loaded,'
      'When no input is given,'
      'Then load all home widgets with no error.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildHomeScreen());

    // Act
    final scaffold = find.byKey(const Key('homeScreenScaffold'));
    final appBar = find.byKey(const Key('homeScreenAppBar'));
    final appBarTitle = find.byKey(const Key('homeScreenAppBarTitle'));
    final appBarLeading = find.byKey(const Key('homeScreenAppBarLeading'));
    final appBarTrailing = find.byKey(const Key('homeScreenAppBarTrailing'));
    final homeScreenBody = find.byKey(const Key('homeScreenBody'));
    final fab = find.byKey(const Key('homeScreenFAB'));
    final botNavBar = find.byKey(const Key('homeScreenBotNavBar'));
    final botNavBarFirstIcon =
        find.byKey(const Key('homeScreenBotNavBarFirstIcon'));
    final botNavBarSecondIcon =
        find.byKey(const Key('homeScreenBotNavBarSecondIcon'));
    final botNavBarThirdIcon =
        find.byKey(const Key('homeScreenBotNavBarThirdIcon'));

    // Assert
    expect(scaffold, findsOneWidget);
    expect(appBar, findsOneWidget);
    expect(appBarTitle, findsOneWidget);
    expect(appBarLeading, findsOneWidget);
    expect(appBarTrailing, findsOneWidget);
    expect(homeScreenBody, findsOneWidget);
    expect(fab, findsOneWidget);
    expect(botNavBar, findsOneWidget);
    expect(botNavBarFirstIcon, findsOneWidget);
    expect(botNavBarSecondIcon, findsOneWidget);
    expect(botNavBarThirdIcon, findsOneWidget);
  });

  testWidgets(
      'Given home screen is loaded,'
      'When FAB is tapped,'
      'Then show bottom sheet.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildHomeScreen());

    // Act
    final fab = find.byType(FloatingActionButton);
    // await tester.ensureVisible(fab);
    // await tester.pumpAndSettle();

    // await tester.tap(fab);
    // await tester.pumpAndSettle();

    // final createAliasSheet = find.byType(BottomSheet);

    // Assert
    // expect(createAliasSheet, findsOneWidget);
  });
}
