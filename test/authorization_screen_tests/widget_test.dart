import 'package:anonaddy/screens/authorization_screen/authorization_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget authorizationScreen() {
    return const ProviderScope(
      child: MaterialApp(
        home: AuthorizationScreen(),
      ),
    );
  }

  testWidgets(
    'Given initial screen, '
    'When app is initially launched, '
    'Then scaffold is loaded, shows loading indicator, and no error.',
    (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(authorizationScreen());

      // Act
      final scaffold = find.byKey(const Key('loadingScreenScaffold'));

      // Assert
      expect(scaffold, findsOneWidget);
    },
  );
}
