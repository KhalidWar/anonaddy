import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_dio.dart';

void main() async {
  late MockDio mockDio;
  late AliasService aliasService;

  setUp(() {
    mockDio = MockDio();
    aliasService = AliasService(dio: mockDio);
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

  test(
      'Given aliasService and dio are up and running, '
      'When aliasService.activateAlias(aliasId) is called, '
      'Then activate alias without any error.', () async {
    // Arrange
    const aliasId = 'fd2258a0-9a40-4825-96c8-ed0f8c38a429';

    // Act
    final dioPost = mockDio.post(aliasId);
    final alias = await aliasService.activateAlias(aliasId);

    // Assert
    expectLater(dioPost, completes);
    expect(await dioPost, isA<Response>());

    expect(alias.active, true);
    expect(alias.id, aliasId);
    expect(alias.domain, 'laylow.io');
    expect(alias.recipients, isA<List>());
  });

  test(
      'Given aliasService and dio are up and running, '
      'When aliasService.activateAlias(error) is called, '
      'Then throw an error.', () async {
    // Arrange
    const aliasId = 'error';

    // Act
    final dioGet = mockDio.post(aliasId);
    final dioError = isA<DioError>();
    final throwsDioError = throwsA(dioError);

    // Assert
    expectLater(dioGet, throwsException);
    expect(dioGet, throwsDioError);
  });

  test(
      'Given aliasService and dio are up and running, '
      'When aliasService.deactivateAlias(aliasId) is called, '
      'Then activate alias without any error.', () async {
    // Arrange
    const aliasId = 'fd2258a0-9a40-4825-96c8-ed0f8c38a429';

    // Act
    final dioPost = mockDio.delete(aliasId);
    await aliasService.deactivateAlias(aliasId);

    // Assert
    expectLater(dioPost, completes);
    expect(await dioPost, isA<Response>());
  });

  test(
      'Given aliasService and dio are up and running, '
      'When aliasService.deactivateAlias(error) is called, '
      'Then throw an error.', () async {
    // Arrange
    const aliasId = 'error';

    // Act
    final dioGet = mockDio.delete(aliasId);
    final dioError = isA<DioError>();
    final throwsDioError = throwsA(dioError);

    // Assert
    expectLater(dioGet, throwsException);
    expect(dioGet, throwsDioError);
  });
}
