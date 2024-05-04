import 'dart:async';

import 'package:anonaddy/features/aliases/data/aliases_service.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final availableAliasesNotifierProvider =
    AsyncNotifierProvider<AvailableAliasesNotifier, List<Alias>>(
        AvailableAliasesNotifier.new);

class AvailableAliasesNotifier extends AsyncNotifier<List<Alias>> {
  Future<void> fetchAliases() async {
    state = await AsyncValue.guard(
      () => ref.read(aliasesServiceProvider).fetchAliases(),
    );
  }

  @override
  FutureOr<List<Alias>> build() async {
    final aliasesService = ref.read(aliasesServiceProvider);

    final cachedAliases = await aliasesService.loadCachedData();

    if (cachedAliases != null) {
      return cachedAliases;
    }

    return await aliasesService.fetchAliases();
  }
}
