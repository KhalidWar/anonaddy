import 'dart:async';

import 'package:anonaddy/features/aliases/data/alias_service.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasesNotifierProvider =
    AsyncNotifierProvider<AliasesNotifier, AliasesState>(AliasesNotifier.new);

class AliasesNotifier extends AsyncNotifier<AliasesState> {
  Future<void> fetchAliases() async {
    state = await AsyncValue.guard(
      () async => Future.value(
        AliasesState(
          availableAliases:
              await ref.read(aliasServiceProvider).fetchAvailableAliases(),
          deletedAliases:
              await ref.read(aliasServiceProvider).fetchDeletedAliases(),
        ),
      ),
    );
  }

  /// Adds specific alias to aliases, mainly used to add newly
  /// created alias to list of available aliases without making an API
  /// request and forcing the user to wait before interacting with the new alias.
  void addAlias(Alias alias) async {
    /// Populates new list from existing state's availableAliasList.
    /// Then, injects [alias] into the first slot in the list.
    final availableAliases = [...state.value!.availableAliases]
      ..insert(0, alias);

    state = AsyncData(
      state.value!.copyWith(availableAliases: availableAliases),
    );
  }

  @override
  FutureOr<AliasesState> build() async {
    final aliasesService = ref.read(aliasServiceProvider);

    final cachedAvailableAliases =
        await aliasesService.loadAvailableAliasesFromDisk();
    final cachedDeletedAliases =
        await aliasesService.loadAvailableAliasesFromDisk();

    if (cachedAvailableAliases != null && cachedDeletedAliases != null) {
      return AliasesState(
        availableAliases: cachedAvailableAliases,
        deletedAliases: cachedDeletedAliases,
      );
    }

    final availableAliases = await aliasesService.fetchAvailableAliases();
    final deletedAliases = await aliasesService.fetchDeletedAliases();

    return AliasesState(
      availableAliases: availableAliases,
      deletedAliases: deletedAliases,
    );
  }
}
