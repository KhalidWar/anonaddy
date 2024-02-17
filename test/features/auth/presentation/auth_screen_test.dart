import 'package:anonaddy/features/auth/presentation/auth_screen.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_state.dart';
import 'package:anonaddy/features/domain_options/domain/domain_options.dart';
import 'package:anonaddy/features/domain_options/presentation/controller/domain_options_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks.dart';

void main() {
  Widget authScreen({
    required AuthState authState,
    required DomainOptions domainOptions,
  }) {
    return ProviderScope(
      overrides: [
        authStateNotifier
            .overrideWith(() => MockAuthNotifier(authState: authState)),
        domainOptionsNotifierProvider.overrideWith(
            () => MockDomainOptionsNotifier(domainOptions: domainOptions)),
      ],
      child: const MaterialApp(
        home: AuthScreen(),
      ),
    );
  }

  testWidgets(
    'Given AuthorizationScreen is constructed, '
    'When auth status is [AuthorizationStatus.anonAddyLogin], '
    'Then display LoadingScreen.',
    (tester) async {
      const authState = AuthState(
        authorizationStatus: AuthorizationStatus.addyLogin,
        authenticationStatus: AuthenticationStatus.disabled,
        loginLoading: false,
      );
      const domainOptions = DomainOptions(domains: [], sharedDomains: []);

      await tester.pumpWidget(authScreen(
        authState: authState,
        domainOptions: domainOptions,
      ));

      expect(
        find.byKey(AuthScreen.authScreenLoadingScreen),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Given AuthorizationScreen is constructed, '
    'When auth status is [AuthorizationStatus.selfHostedLogin], '
    'Then display AnonAddyLoginScreen.',
    (WidgetTester tester) async {
      const authState = AuthState(
        authorizationStatus: AuthorizationStatus.selfHostedLogin,
        authenticationStatus: AuthenticationStatus.disabled,
        loginLoading: false,
      );
      const domainOptions = DomainOptions(domains: [], sharedDomains: []);

      await tester.pumpWidget(authScreen(
        authState: authState,
        domainOptions: domainOptions,
      ));
      await tester.pumpAndSettle();

      expect(
        find.byKey(AuthScreen.authScreenAnonAddyLoginScreen),
        findsNothing,
      );
      expect(
        find.byKey(AuthScreen.authScreenSelfHostedLoginScreen),
        findsOneWidget,
      );
      expect(
        find.byKey(AuthScreen.authScreenHomeScreen),
        findsNothing,
      );
    },
  );

  // testWidgets(
  //   'Given AuthorizationScreen is constructed, '
  //   'When auth status is [AuthorizationStatus.authorized], '
  //   'Then display HomeScreen.',
  //   (WidgetTester tester) async {
  //     const authState = AuthState(
  //       authorizationStatus: AuthorizationStatus.authorized,
  //       authenticationStatus: AuthenticationStatus.disabled,
  //       loginLoading: false,
  //     );
  //     const domainOptions = DomainOptions(domains: [], sharedDomains: []);
  //
  //     await tester.pumpWidget(authScreen(
  //       authState: authState,
  //       domainOptions: domainOptions,
  //     ));
  //     await tester.pumpAndSettle();
  //
  //     expect(find.byKey(AuthScreen.authScreenHomeScreen), findsOneWidget);
  //   },
  // );
}
