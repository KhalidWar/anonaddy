import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_dio.dart';

void main() async {
  late MockDio mockDio;
  late AccountService accountService;

  setUp(() {
    mockDio = MockDio();
    accountService = AccountService(dio: mockDio);
  });

  test(
      'Given accountService and dio are up and running, '
      'When accountService.getAccountData() is called, '
      'Then obtain an account object.', () async {
    // Arrange
    const urlPath = '$kUnEncodedBaseURL/$kAccountDetailsURL';

    // Act
    final dioGet = mockDio.get(urlPath);
    final account = await accountService.getAccounts();

    // Assert
    expectLater(dioGet, completes);
    expect(await dioGet, isA<Response>());

    expect(account, isA<Account>());
    expect(account.username, 'khalidwar');
    expect(account.defaultAliasDomain, 'laylow.io');
    expect(account.totalEmailsForwarded, 1);
  });

  test(
      'Given accountService and dio are up and running, '
      'When accountService.getAccountData() is called, '
      'And is set up to throw an 429 DioError, '
      'Then throw an error.', () async {
    // Arrange

    // Act
    final dioGet = mockDio.get('error');
    final throwsError = throwsA(isA<DioError>());

    // Assert
    expect(() => dioGet, throwsError);
  });
}
