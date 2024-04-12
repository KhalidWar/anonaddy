import 'package:anonaddy/features/rules/domain/rule.dart';
import 'package:anonaddy/features/rules/domain/rule_action.dart';
import 'package:anonaddy/features/rules/domain/rule_condition.dart';

class CreateNewRuleState {
  const CreateNewRuleState({
    required this.rule,
    required this.ruleName,
    required this.conditions,
    required this.actions,
    required this.forwards,
    required this.replies,
    required this.sends,
    required this.operator,
    required this.isLoading,
  });

  final Rule rule;
  final String ruleName;
  final List<RuleCondition> conditions;
  final List<RuleAction> actions;
  final RuleOperator operator;
  final bool forwards;
  final bool replies;
  final bool sends;
  final bool isLoading;

  CreateNewRuleState copyWith({
    Rule? rule,
    String? ruleName,
    List<RuleCondition>? conditions,
    List<RuleAction>? actions,
    RuleOperator? operator,
    bool? forwards,
    bool? replies,
    bool? sends,
    bool? isLoading,
  }) {
    return CreateNewRuleState(
      rule: rule ?? this.rule,
      ruleName: ruleName ?? this.ruleName,
      conditions: conditions ?? this.conditions,
      actions: actions ?? this.actions,
      operator: operator ?? this.operator,
      forwards: forwards ?? this.forwards,
      replies: replies ?? this.replies,
      sends: sends ?? this.sends,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
