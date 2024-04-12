import 'dart:async';

import 'package:anonaddy/features/rules/data/rules_service.dart';
import 'package:anonaddy/features/rules/presentation/controller/create_new_rule_state.dart';
import 'package:anonaddy/features/rules/presentation/controller/rules_tab_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createNewRuleNotifierProvider = AsyncNotifierProvider.family
    .autoDispose<CreateNewRuleNotifier, CreateNewRuleState, String>(
        CreateNewRuleNotifier.new);

class CreateNewRuleNotifier
    extends AutoDisposeFamilyAsyncNotifier<CreateNewRuleState, String> {
  Future<void> updateRule() async {
    final currentState = state.value!;
    state = AsyncData(currentState.copyWith(isLoading: true));

    final ruleData = {
      'name': currentState.ruleName,
      'conditions': currentState.conditions.map((e) => e.toMap()).toList(),
      'actions': currentState.actions.map((e) => e.toMap()).toList(),
      'operator': currentState.operator.name.toUpperCase(),
      'forwards': currentState.forwards,
      'replies': currentState.replies,
      'sends': currentState.sends,
    };

    final updatedRule = await ref
        .read(rulesServiceProvider)
        .updateRule(currentState.rule.id, ruleData);
    await ref.read(rulesTabNotifierProvider.notifier).fetchRules();
  }

  Future<void> updateRuleName(String ruleName) async {
    final currentState = state.value!;
    state = AsyncData(currentState.copyWith(ruleName: ruleName));
  }

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
