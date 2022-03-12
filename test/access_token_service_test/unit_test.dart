import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_flutter_secure_storage.dart';
import 'mock_io_client.dart';

void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late MockIoClient mockHttpClient;
  late AccessTokenService accessTokenService;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    mockHttpClient = MockIoClient();
    accessTokenService = AccessTokenService(
      secureStorage: mockSecureStorage,
      httpClient: mockHttpClient,
    );
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
