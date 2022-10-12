import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/data_storage/alias_data_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_data/alias_test_data.dart';

class _MockDio extends Mock implements Dio {}

class _MockDataStorage extends Mock implements AliasDataStorage {}

void main() async {
  late _MockDio mockDio;
  late _MockDataStorage mockDataStorage;
  late AliasService aliasService;

  setUp(() {
    mockDio = _MockDio();
    mockDataStorage = _MockDataStorage();
    aliasService = AliasService(dio: mockDio, dataStorage: mockDataStorage);
  });

  group('aliasService.fetchSpecificAlias tests ', () {
    test(
        'Given aliasService and dio are up and running, '
        'When aliasService.fetchSpecificAlias(aliasId) is called, '
        'Then future completes and returns an alias data.', () async {
      // Arrange
      final testAlias = AliasTestData.validAliasJson['data'];

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: AliasTestData.validAliasJson,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final alias = await aliasService.fetchSpecificAlias(testAlias['id']);

      // Assert
      expect(alias, isA<Alias>());
      expect(alias.id, testAlias['id']);
      expect(alias.domain, testAlias['domain']);
      expect(alias.recipients, isA<List>());
    });

    // test(
    //     'Given aliasService and dio are up and running, '
    //     'When aliasService.fetchSpecificAlias() is called, '
    //     'Then throw a dioError.', () async {
    //   // Arrange
    //
    //   when(() => mockDio.get(any())).thenThrow(
    //     DioError(
    //       error: DioErrorType.response,
    //       response: Response(
    //         requestOptions: RequestOptions(path: ''),
    //         statusMessage: 'error',
    //       ),
    //       requestOptions: RequestOptions(path: ''),
    //     ),
    //   );
    //
    //   // Assert
    //   expectLater(
    //     () => aliasService.fetchSpecificAlias(''),
    //     throwsA(isA<DioError>()),
    //   );
    // });
  });

  group('aliasService.activateAlias tests ', () {
    test(
        'Given aliasService and dio are up and running, '
        'When aliasService.activateAlias(aliasId) is called, '
        'Then activate alias without any error.', () async {
      // Arrange
      final testAlias = AliasTestData.validAliasJson['data'];

      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: AliasTestData.validAliasJson,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final alias = await aliasService.activateAlias(testAlias['id']);

      // Assert
      expect(alias.active, true);
      expect(alias.id, testAlias['id']);
      expect(alias.domain, testAlias['domain']);
      expect(alias.recipients, isA<List>());
    });

    // test(
    //     'Given aliasService and dio are up and running, '
    //     'When aliasService.activateAlias(error) is called, '
    //     'Then throw an error.', () async {
    //   // Arrange
    //   const aliasId = 'error';
    //
    //   // Act
    //   final dioGet = mockDio.post(aliasId);
    //   final dioError = isA<DioError>();
    //   final throwsDioError = throwsA(dioError);
    //
    //   // Assert
    //   expectLater(dioGet, throwsException);
    //   expect(dioGet, throwsDioError);
    // });
  });

  group('aliasService.deactivateAlias tests ', () {
    test(
        'Given aliasService and dio are up and running, '
        'When aliasService.deactivateAlias() is called, '
        'Then deactivate alias without any error.', () async {
      when(() => mockDio.delete(any())).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: '')),
      );

      // Assert
      expect(aliasService.deactivateAlias(''), completes);
    });

    test(
        'Given aliasService and dio are up and running, '
        'When aliasService.deactivateAlias(error) is called, '
        'Then throw an error.', () async {
      when(() => mockDio.delete(any())).thenThrow(DioError);

      // Assert
      // expect(
      //   () async => await aliasService.deactivateAlias(''),
      //   throwsA(isA<DioError>()),
      // );
    });
  });
}
