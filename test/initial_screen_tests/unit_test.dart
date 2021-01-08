import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // This test is failing due a known FlutterSecureStorage issue
  // (https://github.com/mogol/flutter_secure_storage/issues/152)
  test(
      'Given accessToken is not provided'
      'When app is initially run and accessToken is read from FlutterSecureStorage'
      'Then accessToken should return null', () async {
    // Arrange
    final accessTokenService = AccessTokenService();

    // Act
    final accessToken = await accessTokenService.getAccessToken();

    // Assert
    expect(accessToken, null);
  });
}
