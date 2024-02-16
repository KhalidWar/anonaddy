import 'package:anonaddy/features/account/data/account_service.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../test_data/account_test_data.dart';

void main() async {
  late MockDio mockDio;
  late MockAccountDataStorage mockAccountDataStorage;
  late AccountService accountService;

  setUp(() {
    mockDio = MockDio();
    mockAccountDataStorage = MockAccountDataStorage();
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
      final testAccount =
          Account.fromJson(AccountTestData.validAccountJson['data']);

      when(() => mockAccountDataStorage.saveData(any()))
          .thenAnswer((_) async {});

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: AccountTestData.validAccountJson,
          requestOptions: RequestOptions(path: 'path'),
        ),
      );

      final account = await accountService.fetchAccount();

      expect(account, isA<Account>());
      expect(account.username, testAccount.username);
      expect(account.defaultAliasDomain, testAccount.defaultAliasDomain);
      expect(account.totalEmailsForwarded, testAccount.totalEmailsForwarded);
    });

    // test(
    //     'Given accountService and dio are up and running, '
    //     'When accountService.fetchAccount() is called, '
    //     'And is set up to throw an 429 DioError, '
    //     'Then throw an error.', () async {
    //   when(() => mockAccountDataStorage.saveData(any()))
    //       .thenAnswer((_) async {});
    //
    //   when(() => mockAccountDataStorage.loadData()).thenAnswer(
    //     (_) async => AccountTestData.validAccount(),
    //   );
    //
    //   when(() => mockDio.get(any())).thenThrow(
    //     DioError(
    //       type: DioErrorType.response,
    //       error: 'Error',
    //       requestOptions: RequestOptions(path: ''),
    //     ),
    //   );
    //
    //   final test = await accountService.fetchAccount();
    //
    //   expect(test, throwsA(isA<String>()));
    //   expect(await accountService.fetchAccount(), throwsA(isA<DioError>()));
    // });
  });
}
