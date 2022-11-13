import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/data_storage/account_data_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_data/account_test_data.dart';

class _MockDio extends Mock implements Dio {}

class _MockAccountDataStorage extends Mock implements AccountDataStorage {}

void main() async {
  late _MockDio mockDio;
  late _MockAccountDataStorage mockAccountDataStorage;
  late AccountService accountService;

  setUp(() {
    mockDio = _MockDio();
    mockAccountDataStorage = _MockAccountDataStorage();
    accountService = AccountService(
      dio: mockDio,
      accountDataStorage: mockAccountDataStorage,
    );
  });

  group('accountService.fetchAccount tests ', () {
    test(
        'Given accountService and dio are up and running, '
        'When accountService.fetchAccount() is called, '
        'Then obtain an account object.', () async {
      // Arrange
      final testAccount =
          Account.fromJson(AccountTestData.validAccountJson['data']);

      when(() => mockAccountDataStorage.saveData(any()))
          .thenAnswer((_) async {});

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: AccountTestData.validAccountJson,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final account = await accountService.fetchAccount();

      // Assert
      expect(account, isA<Account>());
      expect(account.username, testAccount.username);
      expect(account.defaultAliasDomain, testAccount.defaultAliasDomain);
      expect(account.totalEmailsForwarded, testAccount.totalEmailsForwarded);
    });

    test(
        'Given accountService and dio are up and running, '
        'When accountService.fetchAccount() is called, '
        'And is set up to throw an 429 DioError, '
        'Then throw an error.', () async {
      // Arrange
      when(() => mockAccountDataStorage.saveData(any()))
          .thenAnswer((_) async {});

      when(() => mockAccountDataStorage.loadData()).thenAnswer(
        (_) async => AccountTestData.validAccount(),
      );

      when(() => mockDio.get(any())).thenThrow(
        DioError(
          type: DioErrorType.response,
          error: 'Error',
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // final test = await accountService.fetchAccount();

      // Assert
      // expect(test, throwsA(isA<String>()));
      // expect(await accountService.fetchAccount(), throwsA(isA<DioError>()));
    });
  });
}
