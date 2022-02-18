import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// class MockLoginStateManager extends Mock implements LoginStateManager {}

class MockClipBoard extends Mock implements Clipboard {}

class MockHttp extends Mock implements HttpClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
      'Given a valid accessToken is provided, '
      'When user is logs in, '
      'Then accessToken is stored in FlutterSecureStorage.', () async {
    // Arrange
    // final loginState = LoginStateManager();
    final textEditingController = TextEditingController();
    // final mockHttp = MockHttp();

    // Act
    await Clipboard.setData(const ClipboardData(text: 'data'));
    // loginState.pasteFromClipboard(textEditingController);

    //Assert
    expect(textEditingController.text, isEmpty);
    // expect(find.text('data'), findsOneWidget);
  });

  test('', () async {
    // Arrange

    // Act

    // Assert
  });
}
