import 'dart:async';

import 'package:anonaddy/features/aliases/data/aliases_service.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deletedAliasesNotifierProvider =
    AsyncNotifierProvider.autoDispose<DeletedAliasesNotifier, List<Alias>?>(
        DeletedAliasesNotifier.new);

class DeletedAliasesNotifier extends AutoDisposeAsyncNotifier<List<Alias>?> {
  Future<void> fetchDeletedAliases() async {
    state = await AsyncValue.guard(
      () => ref
          .read(aliasesServiceProvider)
          .fetchAliases(onlyDeletedAliases: true),
    );
  }

  @override
  FutureOr<List<Alias>?> build() async => null;
}
