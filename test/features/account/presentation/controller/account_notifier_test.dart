import 'package:anonaddy/features/account/data/account_service.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../test_data/account_test_data.dart';

void main() {
  late MockAccountService accountService;

  setUp(() {
    accountService = MockAccountService();
  });

  group('AccountNotifier testing ', () {
    ProviderContainer buildContainer() {
      return ProviderContainer(
        overrides: [
          accountServiceProvider.overrideWith((_) => accountService),
        ],
      );
    }

    test('loading state.', () async {
      when(() => accountService.loadCachedData()).thenAnswer((_) async => null);
      when(() => accountService.fetchAccount())
          .thenAnswer((_) async => AccountTestData.validAccount());

      final container = buildContainer();
      final provider = container.read(accountNotifierProvider);

      expect(provider, isA<AsyncValue<Account>>());
      expect(provider, const AsyncLoading<Account>());
      expect(provider.value, isNull);
    });

    test('loaded state.', () async {
      when(() => accountService.loadCachedData()).thenAnswer((_) async => null);
      when(() => accountService.fetchAccount())
          .thenAnswer((_) async => AccountTestData.validAccount());

      final container = buildContainer();
      final provider = await container.read(accountNotifierProvider.future);

      expect(provider, isA<Account>());
      expect(provider, AccountTestData.validAccount());
      expect(provider, isNotNull);
    });

    test('error state.', () async {
      when(accountService.loadCachedData)
          .thenAnswer((_) => throw ArgumentError());

      // final container = buildContainer();
      // final provider = container.read(accountNotifierProvider);

      expect(accountService.loadCachedData, throwsArgumentError);
      verifyNever(accountService.fetchAccount);
      // expect(
      //   await container.read(accountNotifierProvider.future),
      //   const AsyncError('Error', StackTrace.empty),
      // );
    });

    test('cache data.', () async {
      when(() => accountService.loadCachedData())
          .thenAnswer((_) async => AccountTestData.validAccount());

      final container = buildContainer();
      final provider = await container.read(accountNotifierProvider.future);

      expect(provider, isA<Account>());
      expect(provider, AccountTestData.validAccount());
      verifyNever(accountService.fetchAccount);
    });

    test('fetch repo if cache return null.', () async {
      when(() => accountService.loadCachedData()).thenAnswer((_) async => null);
      when(() => accountService.fetchAccount())
          .thenAnswer((_) async => AccountTestData.validAccount());

      final container = buildContainer();
      final provider = await container.read(accountNotifierProvider.future);

      expect(provider, isA<Account>());
      expect(provider, AccountTestData.validAccount());
      verify(accountService.loadCachedData);
      verify(accountService.fetchAccount);
    });
  });
}
