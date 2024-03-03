import 'package:anonaddy/features/auth/presentation/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget loadingScreen() {
    return const ProviderScope(
      child: MaterialApp(
        home: LoadingScreen(),
      ),
    );
  }

  testWidgets(
    'Given AuthorizationScreen is constructed, '
    'When auth status is [AuthorizationStatus.unknown], '
    'Then display LoadingScreen.',
    (WidgetTester tester) async {
      await tester.pumpWidget(loadingScreen());

      expect(
        find.byKey(LoadingScreen.loadingScreenScaffold),
        findsOneWidget,
      );
      expect(
        find.byKey(LoadingScreen.loadingScreenAppLogo),
        findsOneWidget,
      );
      expect(
        find.byKey(LoadingScreen.loadingScreenLoadingIndicator),
        findsOneWidget,
      );
    },
  );

  // testWidgets(
  //   'Given AuthorizationScreen is constructed, '
  //   'When auth status is [AuthorizationStatus.unknown], '
  //   'And LoadingScreen is displayed for 10+ seconds, '
  //   'Then display LoadingScreen with logout button.',
  //   (WidgetTester tester) async {
  //     await tester.pumpWidget(loadingScreen());
  //     const duration = Duration(seconds: 11);
  //     await tester.pumpAndSettle(duration);
  //
  //     expect(
  //       find.byKey(LoadingScreen.loadingScreenScaffold),
  //       findsOneWidget,
  //     );
  //     expect(
  //       find.byKey(LoadingScreen.loadingScreenAppLogo),
  //       findsOneWidget,
  //     );
  //     expect(
  //       find.byKey(LoadingScreen.loadingScreenLoadingIndicator),
  //       findsOneWidget,
  //     );
  //     expect(
  //       find.byKey(LoadingScreen.loadingScreenLogoutButton),
  //       findsOneWidget,
  //     );
  //   },
  // );
}
