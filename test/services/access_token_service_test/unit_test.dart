import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late MockDio mockDio;
  late AuthService accessTokenService;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    mockDio = MockDio();
    accessTokenService =
        AuthService(secureStorage: mockSecureStorage, dio: mockDio);
  });

  test(
      'Given AccessTokenService is constructed, '
      'When .validateAccessToken() is called with a url and token, '
      'Then return true.', () async {
    // Act
    final isValid =
        await accessTokenService.validateAccessToken('url', 'token');

    // Assert
    expect(isValid, true);
    verifyNoMoreInteractions(mockDio);
  });

  test(
      'Given access token service is constructed, '
      'When .getAccessToken() is called, '
      'Then return an empty String.', () async {
    // Act
    final token = await accessTokenService.getAccessToken();

    // Assert
    expect(token, isEmpty);
  });

  test(
      'Given access token service is constructed, '
      'When .getAccessToken() is called with a random key, '
      'Then return an empty String.', () async {
    // Act
    final token = await accessTokenService.getAccessToken(key: 'awef');

    // Assert
    expect(token, isEmpty);
  });

  test(
      'Given access token service is constructed,'
      'When .saveLoginCredentials() is called,'
      'Then return nothing.', () async {
    // Act
    await accessTokenService.saveLoginCredentials('url', 'token');

    // Assert
    // verify(mockSecureStorage.write(key: any.toString(), value: any)).called(2);
  });
}
