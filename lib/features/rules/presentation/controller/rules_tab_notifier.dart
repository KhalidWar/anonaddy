import 'dart:async';

import 'package:anonaddy/features/rules/data/rules_service.dart';
import 'package:anonaddy/features/rules/domain/rules.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rulesTabNotifierProvider =
    AsyncNotifierProvider<RulesTabNotifier, List<Rules>>(RulesTabNotifier.new);

class RulesTabNotifier extends AsyncNotifier<List<Rules>> {
  /// Fetch all [Rules]s associated with user's account
  Future<void> fetchRules() async {
    try {
      final rules = await ref.read(rulesService).fetchRules();

      state = AsyncData(rules);
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.empty);
      await _retryOnError();
    }
  }

  Future _retryOnError() async {
    if (state is AsyncError) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchRules();
    }
  }

  @override
  FutureOr<List<Rules>> build() async {
    final service = ref.read(rulesService);

    final rules = await service.loadRulesFromDisk();
    if (rules == null) return await service.fetchRules();
    return rules;
  }
}
