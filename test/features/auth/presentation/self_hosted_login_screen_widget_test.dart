import 'package:anonaddy/features/auth/presentation/components/self_host_login_screen.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  Widget buildSelfHostedScreen() {
    return const ProviderScope(
      child: MaterialApp(
        home: SelfHostLoginScreen(),
      ),
    );
  }

  testWidgets(
      'Given SelfHostLoginScreen is loaded, '
      'When no input is given, '
      'Then show screen with no errors.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildSelfHostedScreen());

    // Act
    final scaffold = find.byKey(const Key('selfHostedLoginScreenScaffold'));
    final appBar = find.byType(AppBar);
    final urlInputLabel =
        find.byKey(const Key('selfHostedLoginScreenUrlInputLabel'));
    final urlInputField =
        find.byKey(const Key('selfHostedLoginScreenUrlInputField'));
    final tokenInputLabel =
        find.byKey(const Key('selfHostedLoginScreenTokenInputLabel'));
    final tokenInputField =
        find.byKey(const Key('selfHostedLoginScreenTokenInputField'));
    final infoButton =
        find.byKey(const Key('selfHostedLoginScreenSelfHostInfoButton'));
    final loginButton = find.byKey(const Key('loginFooterLoginButton'));
    final loginButtonLoading =
        find.byKey(const Key('loginFooterLoginButtonLoading'));
    final loginButtonLabel =
        find.byKey(const Key('selfHostedLoginScreenLoginFooter'));
    final urlInputHintText = find.text(AppUrl.anonAddyAuthority);
    final tokenInputHintText = find.text(AppStrings.enterYourApiToken);

    // Assert
    expect(scaffold, findsOneWidget);
    expect(appBar, findsOneWidget);
    expect(urlInputLabel, findsOneWidget);
    expect(urlInputField, findsOneWidget);
    expect(tokenInputLabel, findsOneWidget);
    expect(tokenInputField, findsOneWidget);
    expect(infoButton, findsOneWidget);
    expect(loginButton, findsOneWidget);
    expect(loginButtonLoading, findsNothing);
    expect(loginButtonLabel, findsOneWidget);
    expect(urlInputHintText, findsOneWidget);
    expect(tokenInputHintText, findsOneWidget);
  });

  testWidgets(
      'Given instance URL input field is empty, '
      'When login button is tapped, '
      'Then display URL validator error text and no token validator error.',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildSelfHostedScreen());

    // Act
    final loginButton = find.byKey(const Key('loginFooterLoginButton'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    final urlValidatorErrorText = find.text(AppStrings.providerValidUrl);
    final tokenValidatorErrorText =
        find.text(AppStrings.provideValidAccessToken);

    // Assert
    expect(urlValidatorErrorText, findsOneWidget);
    expect(tokenValidatorErrorText, findsNothing);
  });

  testWidgets(
      'Given instance URL input field is populated, '
      'When login button is tapped,'
      'Then display token validator error text and no url validator error.',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildSelfHostedScreen());

    // Act
    final urlInput =
        find.byKey(const Key('selfHostedLoginScreenUrlInputField'));
    await tester.enterText(urlInput, 'text');

    final loginButton = find.byKey(const Key('loginFooterLoginButton'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    final urlValidatorErrorText = find.text(AppStrings.providerValidUrl);
    final tokenValidatorErrorText =
        find.text(AppStrings.provideValidAccessToken);

    // Assert
    expect(urlValidatorErrorText, findsNothing);
    expect(tokenValidatorErrorText, findsOneWidget);
  });
}
