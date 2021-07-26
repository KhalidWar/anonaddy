import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/state_management/login_state_manager.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLoginStateManager extends Mock implements LoginStateManager {
  MockLoginStateManager(this._isLoading);
  late bool _isLoading;

  @override
  bool get isLoading => _isLoading;

  @override
  set isLoading(bool toggle) {
    _isLoading = toggle;
    notifyListeners();
  }
}

void main() {
  Widget rootWidget({Widget? child}) {
    return ProviderScope(child: MaterialApp(home: child));
  }

  testWidgets(
      'When app initially launches, '
      'Then scaffold, textField, and button load, '
      'and no loading or errors.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(rootWidget(child: TokenLoginScreen()));

    // LoginStateManagerTest().setIsLoading(true);

    // Act
    final loginScreenScaffold = find.byKey(Key('loginScreenScaffold'));
    final textField = find.byKey(Key('loginTextField'));
    final loginButton = find.byKey(Key('loginButton'));
    final loadingIndicator = find.byKey(Key('loginLoadingIndicator'));

    // Assert
    expect(loginScreenScaffold, findsOneWidget);
    expect(textField, findsOneWidget);
    expect(loginButton, findsOneWidget);
    expect(loadingIndicator, findsNothing);
  });

  testWidgets(
      'Given empty textField, '
      'When login button is tapped, '
      'Then throw a form validation error.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(rootWidget(child: TokenLoginScreen()));

    // Act
    final loginButton = find.byKey(Key('loginButton'));
    await tester.tap(loginButton);
    await tester.pump();

    // Assert
    expect(loginButton, findsOneWidget);
    expect(find.text('Please Enter Access Token'), findsOneWidget);
  });

  testWidgets(
      'Given empty textField '
      'When text is entered in textField, '
      'Then show entered text.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(rootWidget(child: TokenLoginScreen()));

    // Act
    final textFormField = find.byKey(Key('loginTextField'));
    await tester.enterText(textFormField, 'text');

    // Assert
    expect(textFormField, findsOneWidget);
    expect(find.text('text'), findsOneWidget);
  });

  testWidgets(
      'Given login screen is loaded, '
      'When "How to get access Token?" is pressed, '
      'Then show a dialog.', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(rootWidget(child: TokenLoginScreen()));

    // Act
    final getAccessToken = find.byKey(Key('loginGetAccessToken'));
    await tester.tap(getAccessToken);
    await tester.pump();

    // Assert
    expect(getAccessToken, findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('override providers', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(ProviderScope(
      overrides: [
        loginStateManagerProvider.overrideWithProvider(
          Provider((ref) => MockLoginStateManager(true)),
        )
      ],
      child: MaterialApp(home: TokenLoginScreen()),
    ));

    // Act
    final textField = find.byKey(Key('loginTextField'));
    await tester.enterText(textField, 'text');
    await tester.pump();

    final loginButton = find.byKey(Key('loginButton'));
    //todo fix tap is not working.
    await tester.tap(loginButton);
    await tester.pump();

    // Assert
    expect(textField, findsOneWidget);
    expect(find.text('text'), findsOneWidget);
    expect(loginButton, findsOneWidget);

    // it is loading because class constructor sets isLoading to true
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
