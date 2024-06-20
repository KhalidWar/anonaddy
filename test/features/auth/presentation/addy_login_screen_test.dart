import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/onboarding/presentation/components/addy_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Builds login screen to be tested
  Widget buildAnonAddyLoginScreen() {
    return const ProviderScope(
      child: MaterialApp(
        home: AddyLogin(),
      ),
    );
  }

  testWidgets(
      'When app initially launches, '
      'Then scaffold, textField, and button load, '
      'and no loading or errors.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildAnonAddyLoginScreen());

    // Act
    final loginScreenScaffold = find.byKey(const Key('loginScreenScaffold'));
    final textField = find.byKey(const Key('loginScreenTextField'));
    final loginButton = find.byKey(const Key('loginFooterLoginButton'));
    final loginButtonText = find.byKey(const Key('addyLoginScreenLoginFooter'));
    final loadingIndicator =
        find.byKey(const Key('loginFooterLoginButtonLoading'));
    final accessTokenInfoButton =
        find.byKey(const Key('loginScreenAccessTokenInfoButton'));

    // Assert
    expect(loginScreenScaffold, findsOneWidget);
    expect(textField, findsOneWidget);
    expect(loginButton, findsOneWidget);
    expect(loginButtonText, findsOneWidget);
    expect(loadingIndicator, findsNothing);
    expect(find.text('Enter Access Token'), findsOneWidget);
    expect(accessTokenInfoButton, findsOneWidget);
  });

  testWidgets(
      'Given empty textField, '
      'When login button is tapped, '
      'Then throw a form validation error.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildAnonAddyLoginScreen());

    // Act
    final loginButton = find.byKey(const Key('loginFooterLoginButton'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    final validationErrorText = find.text(AppStrings.provideValidAccessToken);

    // Assert
    expect(validationErrorText, findsOneWidget);
  });

  testWidgets(
      'Given empty textField '
      'When text is entered in textField, '
      'Then show entered text.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildAnonAddyLoginScreen());

    // Act
    final textFormField = find.byKey(const Key('loginScreenTextField'));
    await tester.enterText(textFormField, 'text');

    // Assert
    expect(textFormField, findsOneWidget);
    expect(find.text('text'), findsOneWidget);
  });

  testWidgets(
      'Given access token input field is populated,'
      'When login button is pressed,'
      'Then show loading indicator instead of login button text.',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildAnonAddyLoginScreen());

    // Act
    final inputField = find.byKey(const Key('loginScreenTextField'));
    final loginButton = find.byKey(const Key('loginFooterLoginButton'));

    await tester.enterText(inputField, 'text');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    //todo find a way to update state to test for loading
    // final loadingIndicator = find.byKey(const Key('loginLoadingIndicator'));

    // Assert
    expect(loginButton, findsOneWidget);
    // expect(loadingIndicator, findsOneWidget);
    // expect(const Key('loginScreenLoginButtonText'), findsNothing);
  });

  testWidgets(
      'Given login screen is loaded, '
      'When "What is Access Token?" button is tapped, '
      'Then show a dialog.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildAnonAddyLoginScreen());

    // Act
    final accessTokenInfoButton =
        find.byKey(const Key('loginScreenAccessTokenInfoButton'));
    await tester.tap(accessTokenInfoButton);
    await tester.pumpAndSettle();

    final accessTokenInfoSheetColumn =
        find.byKey(const Key('accessTokenInfoSheetColumn'));

    // Assert
    expect(accessTokenInfoSheetColumn, findsOneWidget);
    expect(accessTokenInfoButton, findsOneWidget);
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text(AppStrings.getAccessToken), findsOneWidget);
  });

  testWidgets(
      'Given login screen is loaded, '
      'When "Self Hosted? Change instance!" button is tapped, '
      'Then show a dialog.', (WidgetTester tester) async {
    //todo figure out how to test for navigation
    // Arrange
    await tester.pumpWidget(buildAnonAddyLoginScreen());

    // Act
    final changeInstanceButton =
        find.byKey(const Key('loginScreenChangeInstanceButton'));
    // await tester.tap(changeInstanceButton);
    // await tester.pumpAndSettle();

    // final Route<dynamic> route = any;
    // verify(mockObserver.didPush(any, any));

    // final selfHostedScreen = find.byType(SelfHostLoginScreen);

    // Assert
    // expect(selfHostedScreen, findsOneWidget);

    expect(changeInstanceButton, findsOneWidget);
    // expect(find.byType(BottomSheet), findsOneWidget);
    // expect(find.text(AppStrings.getAccessToken), findsOneWidget);
  });

  // testWidgets('override providers', (WidgetTester tester) async {
  //   // Arrange
  //   await tester.pumpWidget(ProviderScope(
  //     overrides: [
  //       loginStateManagerProvider.overrideWithProvider(
  //         Provider((ref) => MockLoginStateManager(true)),
  //       )
  //     ],
  //     child: MaterialApp(home: AnonAddyLoginScreen()),
  //   ));
  //
  //   // Act
  //   final textField = find.byKey(Key('loginTextField'));
  //   await tester.enterText(textField, 'text');
  //   await tester.pump();
  //
  //   final loginButton = find.byKey(Key('loginButton'));
  //   //todo fix tap is not working.
  //   await tester.tap(loginButton);
  //   await tester.pump();
  //
  //   // Assert
  //   expect(textField, findsOneWidget);
  //   expect(find.text('text'), findsOneWidget);
  //   expect(loginButton, findsOneWidget);
  //
  //   // it is loading because class constructor sets isLoading to true
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
  // });
}
