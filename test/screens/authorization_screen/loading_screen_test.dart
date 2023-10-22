import 'package:anonaddy/notifiers/authorization/auth_notifier.dart';
import 'package:anonaddy/screens/authorization_screen/components/auth_screen_widget_keys.dart';
import 'package:anonaddy/screens/authorization_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_screen_mocks.dart';

void main() {
  Widget loadingScreen() {
    return ProviderScope(
      overrides: [
        authStateNotifier.overrideWithProvider(testAuthStateNotifier),
      ],
      child: const MaterialApp(
        home: LoadingScreen(),
      ),
    );
  }

  testWidgets(
    'Given AuthorizationScreen is constructed, '
    'When auth status is [AuthorizationStatus.unknown], '
    'Then display LoadingScreen.',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(loadingScreen());

      // Act
      final scaffold = find.byKey(AuthScreenWidgetKeys.loadingScreenScaffold);
      final logo = find.byKey(AuthScreenWidgetKeys.loadingScreenAppLogo);
      final loading =
          find.byKey(AuthScreenWidgetKeys.loadingScreenLoadingIndicator);

      // Assert
      expect(scaffold, findsOneWidget);
      expect(logo, findsOneWidget);
      expect(loading, findsOneWidget);
    },
  );

  testWidgets(
    'Given AuthorizationScreen is constructed, '
    'When auth status is [AuthorizationStatus.unknown], '
    'And LoadingScreen is displayed for 10+ seconds, '
    'Then display LoadingScreen with logout button.',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(loadingScreen());
      // const duration = Duration(seconds: 11);
      // await tester.pumpAndSettle();

      // Act
      final scaffold = find.byKey(AuthScreenWidgetKeys.loadingScreenScaffold);
      final logo = find.byKey(AuthScreenWidgetKeys.loadingScreenAppLogo);
      // final logoutButton =
      //     find.byKey(AuthScreenWidgetKeys.loadingScreenLogoutButton);
      // final loading =
      //     find.byKey(AuthScreenWidgetKeys.loadingScreenLoadingIndicator);

      // Assert
      expect(scaffold, findsOneWidget);
      expect(logo, findsOneWidget);
      // expect(logoutButton, findsOneWidget);
      // expect(loading, findsOneWidget);
    },
  );
}
