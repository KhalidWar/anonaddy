import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestable({Widget child}) {
    return ProviderScope(
      child: MaterialApp(home: child),
    );
  }

  testWidgets('find login text field', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(child: TokenLoginScreen()));

    Finder textField = find.byKey(Key('loginTextField'));
    expect(textField, findsOneWidget);

    Finder loginButton = find.byKey(Key('loginButton'));
    expect(loginButton, findsOneWidget);
  });
}
