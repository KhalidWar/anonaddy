import 'dart:async';

import 'package:anonaddy/features/rules/data/rules_service.dart';
import 'package:anonaddy/features/rules/presentation/controller/create_new_rule_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createNewRuleNotifierProvider = AsyncNotifierProvider.family
    .autoDispose<CreateNewRuleNotifier, CreateNewRuleState, String>(
        CreateNewRuleNotifier.new);

class CreateNewRuleNotifier
    extends AutoDisposeFamilyAsyncNotifier<CreateNewRuleState, String> {
  void toggleForwards(bool? forwards) {
    final currentState = state.value!;
    state = AsyncData(currentState.copyWith(forwards: forwards));
  }

  void toggleReplies(bool? replies) {
    final currentState = state.value!;
    state = AsyncData(currentState.copyWith(replies: replies));
  }

  void toggleSends(bool? sends) {
    final currentState = state.value!;
    state = AsyncData(currentState.copyWith(sends: sends));
  }

  @override
  FutureOr<CreateNewRuleState> build(String arg) async {
    final service = ref.read(rulesServiceProvider);
    final rule = await service.fetchSpecificRule(arg);

    return CreateNewRuleState(
      rule: rule,
      ruleName: rule.name,
      conditions: rule.conditions,
      actions: rule.actions,
      operator: rule.operator,
      forwards: rule.forwards,
      replies: rule.replies,
      sends: rule.sends,
      isLoading: false,
    );
  }
}
