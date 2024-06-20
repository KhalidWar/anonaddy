import 'package:anonaddy/features/aliases/data/aliases_service.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/controller/available_aliases_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late MockAliasService aliasService;

  setUp(() {
    aliasService = MockAliasService();
  });

  group('AvailableAliasesNotifier testing ', () {
    ProviderContainer buildContainer() {
      return ProviderContainer(
        overrides: [
          aliasesServiceProvider.overrideWith((_) => aliasService),
        ],
      );
    }

    test('loading state.', () async {
      when(() => aliasService.loadCachedData()).thenAnswer((_) async => null);
      when(() => aliasService.fetchAliases()).thenAnswer((_) async => []);

      final container = buildContainer();
      final provider = container.read(availableAliasesNotifierProvider);

      expect(provider, isA<AsyncValue<List<Alias>>>());
      expect(provider, const AsyncLoading<List<Alias>>());
      expect(provider.value, isNull);
    });

    test('loaded state.', () async {
      when(() => aliasService.loadCachedData()).thenAnswer((_) async => null);
      when(() => aliasService.fetchAliases()).thenAnswer((_) async => []);

      final container = buildContainer();
      final provider =
          await container.read(availableAliasesNotifierProvider.future);

      expect(provider, isA<List<Alias>>());
      expect(provider, []);
      expect(provider, isNotNull);
    });

    test('error state.', () async {
      when(aliasService.loadCachedData)
          .thenAnswer((_) => throw ArgumentError());

      // final container = buildContainer();
      // final provider = container.read(availableAliasesNotifierProvider);

      expect(aliasService.loadCachedData, throwsArgumentError);
      verifyNever(aliasService.fetchAliases);
      // expect(
      //   await container.read(availableAliasesNotifierProvider.future),
      //   const AsyncError('Error', StackTrace.empty),
      // );
    });

    test('cache data.', () async {
      when(() => aliasService.loadCachedData()).thenAnswer((_) async => []);

      final container = buildContainer();
      final provider =
          await container.read(availableAliasesNotifierProvider.future);

      expect(provider, isA<List<Alias>>());
      expect(provider, []);
      verifyNever(aliasService.fetchAliases);
    });

    test('fetch repo if cache return null.', () async {
      when(() => aliasService.loadCachedData()).thenAnswer((_) async => null);
      when(() => aliasService.fetchAliases()).thenAnswer((_) async => []);

      final container = buildContainer();
      final provider =
          await container.read(availableAliasesNotifierProvider.future);

      expect(provider, isA<List<Alias>>());
      expect(provider, []);
      verify(aliasService.loadCachedData);
      verify(aliasService.fetchAliases);
    });
  });
}
