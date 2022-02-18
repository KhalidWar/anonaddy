import 'package:anonaddy/screens/authorization_screen/authorization_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget rootWidget({Widget? child}) {
    return ProviderScope(child: MaterialApp(home: child));
  }

  testWidgets(
      'Given initial screen, '
      'When app is initially launched, '
      'Then scaffold is loaded, shows loading indicator, and no error.',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(rootWidget(child: const AuthorizationScreen()));

    // Act
    final scaffold = find.byKey(const Key('initialScreenScaffold'));
    final loadingIndicator = find.byKey(const Key('loadingIndicator'));
    final errorWidget = find.byKey(const Key('errorWidget'));

    // Assert
    expect(scaffold, findsOneWidget);
    expect(loadingIndicator, findsOneWidget);
    expect(errorWidget, findsNothing);
  });
}
