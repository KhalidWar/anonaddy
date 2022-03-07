import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAlias extends Mock implements Alias {}

/// Widget test for [AliasScreen]
void main() async {
  late MockAlias mockAlias;
  late Widget testWidget;

  setUp(() {
    mockAlias = MockAlias();
    testWidget = ProviderScope(
      child: MaterialApp(
        home: AliasScreen(
          alias: mockAlias,
        ),
      ),
    );
  });

  testWidgets('description', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(testWidget);

    // Act
    final scaffold = find.byKey(const Key('aliasScreenScaffold'));

    // Assert
    expect(scaffold, findsOneWidget);
  });
}
