import 'package:anonaddy/features/auth/data/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late MockDio mockDio;
  late AuthService authService;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    mockDio = MockDio();
    authService = AuthService(secureStorage: mockSecureStorage, dio: mockDio);
  });

  // test(
  //     'Given AccessTokenService is constructed, '
  //     'When .validateAccessToken() is called with a url and token, '
  //     'Then return true.', () async {
  //   // Act
  //   final isValid = await authService.validateAccessToken('url', 'token');
  //
  //   // Assert
  //   expect(isValid, true);
  //   verifyNoMoreInteractions(mockDio);
  // });
  //
  // test(
  //     'Given access token service is constructed, '
  //     'When .getAccessToken() is called, '
  //     'Then return an empty String.', () async {
  //   // Act
  //   final token = await authService.getAccessToken();
  //
  //   // Assert
  //   expect(token, isEmpty);
  // });
  //
  // test(
  //     'Given access token service is constructed, '
  //     'When .getAccessToken() is called with a random key, '
  //     'Then return an empty String.', () async {
  //   // Act
  //   final token = await authService.getUser();
  //
  //   // Assert
  //   expect(token, isEmpty);
  // });
  //
  // test(
  //     'Given access token service is constructed,'
  //     'When .saveLoginCredentials() is called,'
  //     'Then return nothing.', () async {
  //   // Act
  //   await authService.saveUser();
  //
  //   // Assert
  //   // verify(mockSecureStorage.write(key: any.toString(), value: any)).called(2);
  // });
}
