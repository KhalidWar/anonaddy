import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock_dio.dart';

class MockAccessTokenService extends Mock implements AccessTokenService {}

void main() async {
  late MockDio mockDio;
  late MockAccessTokenService mockAccessTokenService;
  late AliasService aliasService;

  setUp(() {
    mockDio = MockDio();
    mockAccessTokenService = MockAccessTokenService();
    aliasService = AliasService(mockAccessTokenService, mockDio);
  });

  test(
      'Given aliasService and dio are up and running, '
      'When aliasService.getSpecificAlias(aliasId) is called, '
      'Then future completes and returns an alias data.', () async {
    // Arrange
    const aliasId = 'fd2258a0-9a40-4825-96c8-ed0f8c38a429';

    // Act
    final dioGet = mockDio.get(aliasId);
    final alias = await aliasService.getSpecificAlias(aliasId);

    // Assert
    expectLater(dioGet, completes);
    expect(await dioGet, isA<Response>());

    expect(alias, isA<Alias>());
    expect(alias.id, aliasId);
    expect(alias.domain, 'laylow.io');
    expect(alias.recipients, isA<List>());
    expect(alias.recipients![0].shouldEncrypt, false);
  });

  test(
      'Given aliasService and dio are up and running, '
      'When aliasService.getSpecificAlias(error) is called, '
      'Then throw an dioError.', () async {
    // Arrange
    const aliasId = 'error';

    // Act
    final dioGet = mockDio.get(aliasId);
    final dioError = isA<DioError>();
    final throwsDioError = throwsA(dioError);

    // Assert
    expectLater(dioGet, throwsException);
    expect(dioGet, throwsDioError);
  });
}
