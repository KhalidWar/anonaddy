import 'dart:async';

import 'package:anonaddy/features/aliases/data/alias_service.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasesNotifierProvider =
    AsyncNotifierProvider<AliasesNotifier, List<Alias>>(AliasesNotifier.new);

class AliasesNotifier extends AsyncNotifier<List<Alias>> {
  Future<void> fetchAliases() async {
    state = await AsyncValue.guard(
      () => ref.read(aliasServiceProvider).fetchAliases(),
    );
  }

  @override
  FutureOr<List<Alias>> build() async {
    final aliasesService = ref.read(aliasServiceProvider);

    final cachedAliases = await aliasesService.loadAliasesFromDisk();

    if (cachedAliases != null) {
      return cachedAliases;
    }

    return await aliasesService.fetchAliases();
  }
}
