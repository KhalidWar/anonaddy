import 'dart:async';

import 'package:anonaddy/features/rules/data/rules_service.dart';
import 'package:anonaddy/features/rules/domain/rule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rulesTabNotifierProvider =
    AsyncNotifierProvider.autoDispose<RulesTabNotifier, List<Rule>>(
        RulesTabNotifier.new);

class RulesTabNotifier extends AutoDisposeAsyncNotifier<List<Rule>> {
  /// Fetch all [Rule]s associated with user's account
  Future<void> fetchRules({bool showLoading = false}) async {
    if (showLoading) state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(rulesServiceProvider).fetchRules());
  }

  @override
  FutureOr<List<Rule>> build() async {
    final service = ref.read(rulesServiceProvider);

    final rules = await service.loadCachedData();
    if (rules == null) return await service.fetchRules();
    return rules;
  }
}
