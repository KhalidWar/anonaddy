import 'dart:convert';

import 'package:anonaddy/features/account/data/account_service.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../test_data/account_test_data.dart';

void main() async {
  late String storageKey;
  late MockDio mockDio;
  late MockFlutterSecureStorage secureStorage;
  late AccountService accountService;

  setUp(() {
    mockDio = MockDio();
    secureStorage = MockFlutterSecureStorage();
    storageKey = 'accountKey';
    accountService = AccountService(
      dio: mockDio,
      secureStorage: secureStorage,
      storageKey: storageKey,
    );
  });

  group('accountService.fetchAccount tests ', () {
    test(
        'Given AccountService is set up, '
        'When fetchAccount() is called, '
        'Then call account API endpoint, '
        'And store account data, '
        'And get account object.', () async {
      final testAccount =
          Account.fromJson(AccountTestData.validAccountJson['data']);

      when(() => mockDio.get('/api/v1/account-details')).thenAnswer(
        (_) async => Response(
          data: AccountTestData.validAccountJson,
          requestOptions: RequestOptions(path: 'path'),
        ),
      );

      final account = await accountService.fetchAccount();

      verify(() => mockDio.get('/api/v1/account-details')).called(1);
      verify(() => secureStorage.write(
            key: storageKey,
            value: jsonEncode(AccountTestData.validAccountJson),
          )).called(1);

      expect(account, isA<Account>());
      expect(account.username, testAccount.username);
      expect(account.defaultAliasDomain, testAccount.defaultAliasDomain);
      expect(account.totalEmailsForwarded, testAccount.totalEmailsForwarded);
    });

    test(
        'Given AccountService is set up, '
        'When fetchAccount() is called, '
        'And Dio throw exception connectionError, '
        'Then load cached data.', () async {
      final testAccount =
          Account.fromJson(AccountTestData.validAccountJson['data']);

      when(() => mockDio.get(any())).thenThrow(
        DioException(
          type: DioExceptionType.connectionError,
          error: 'Your internet connection is gone',
          requestOptions: RequestOptions(path: ''),
        ),
      );

      when(() => secureStorage.readAll()).thenAnswer(
        (_) async => Future.value({
          storageKey: jsonEncode(AccountTestData.validAccountJson),
        }),
      );

      final account = await accountService.fetchAccount();

      expect(account, isA<Account>());
      expect(account, isA<Account>());
      expect(account.username, testAccount.username);
      expect(account.defaultAliasDomain, testAccount.defaultAliasDomain);
      expect(account.totalEmailsForwarded, testAccount.totalEmailsForwarded);
    });

    test(
        'Given accountService and dio are up and running, '
        'When accountService.fetchAccount() is called, '
        'Then obtain an account object.', () async {
      final testAccount =
          Account.fromJson(AccountTestData.validAccountJson['data']);

      when(() => secureStorage.readAll()).thenAnswer(
        (_) async => Future.value({
          storageKey: jsonEncode(AccountTestData.validAccountJson),
        }),
      );

      final account = await accountService.loadCachedData();

      expect(account, isA<Account>());
      expect(account?.username, testAccount.username);
      expect(account?.defaultAliasDomain, testAccount.defaultAliasDomain);
      expect(account?.totalEmailsForwarded, testAccount.totalEmailsForwarded);
    });
  });
}
