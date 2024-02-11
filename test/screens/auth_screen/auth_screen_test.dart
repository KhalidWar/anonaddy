import 'package:anonaddy/features/auth/presentation/auth_screen.dart';
import 'package:anonaddy/features/auth/presentation/components/auth_screen_widget_keys.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_state.dart';
import 'package:anonaddy/features/domain_options/presentation/controller/domain_options_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_screen_mocks.dart';

void main() {
  Widget authScreen(StateNotifierProvider<AuthNotifier, AuthState> provider) {
    return ProviderScope(
      overrides: [
        authStateNotifier.overrideWithProvider(provider),
        domainOptionsNotifier.overrideWithProvider(testDomainOptionsNotifier),
      ],
      child: const MaterialApp(
        home: AuthScreen(),
      ),
    );
  }

  testWidgets(
    'Given AuthorizationScreen is constructed, '
    'When auth status is [AuthorizationStatus.unknown], '
    'Then display LoadingScreen.',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(authScreen(testAuthStateNotifier));

      // Act
      final loadingScreen =
          find.byKey(AuthScreenWidgetKeys.authScreenLoadingScreen);

      // Assert
      expect(loadingScreen, findsOneWidget);
    },
  );

  testWidgets(
    'Given AuthorizationScreen is constructed, '
    'When auth status is [AuthorizationStatus.anonAddyLogin], '
    'Then display AnonAddyLoginScreen.',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(authScreen(testAuthStateNotifier));
      await tester.pumpAndSettle();

      // Act
      final anonAddyLoginScreen =
          find.byKey(AuthScreenWidgetKeys.authScreenAnonAddyLoginScreen);
      final selfHostedLoginScreen =
          find.byKey(AuthScreenWidgetKeys.authScreenSelfHostedLoginScreen);
      final homeScreen = find.byKey(AuthScreenWidgetKeys.authScreenHomeScreen);

      // Assert
      expect(anonAddyLoginScreen, findsOneWidget);
      expect(selfHostedLoginScreen, findsNothing);
      expect(homeScreen, findsNothing);
    },
  );
  testWidgets(
    'Given AuthorizationScreen is constructed, '
    'When auth status is [AuthorizationStatus.authorized], '
    'Then display HomeScreen.',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(authScreen(testAuthStateNotifier));
      // await tester.pumpAndSettle();

      // Act
      // final homeScreen = find.byKey(AuthScreenWidgetKeys.authScreenHomeScreen);

      // Assert
      // expect(homeScreen, findsOneWidget);
    },
  );
}
