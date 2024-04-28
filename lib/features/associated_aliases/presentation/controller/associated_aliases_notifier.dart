import 'dart:async';

import 'package:anonaddy/features/aliases/data/alias_service.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final associatedAliasesNotifierProvider = AsyncNotifierProvider.family
    .autoDispose<AssociatedAliasesNotifier, List<Alias>?, Map<String, String>>(
        AssociatedAliasesNotifier.new);

class AssociatedAliasesNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Alias>?, Map<String, String>> {
  @override
  FutureOr<List<Alias>?> build(Map<String, String> arg) async {
    final aliasesService = ref.read(aliasesServiceProvider);
    return await aliasesService.fetchAssociatedAliases(arg);
  }
}
