import 'package:anonaddy/features/rules/domain/rule.dart';
import 'package:anonaddy/features/rules/domain/rule_action.dart';
import 'package:anonaddy/features/rules/domain/rule_condition.dart';
import 'package:anonaddy/features/rules/domain/rule_operator.dart';

class CreateNewRuleState {
  const CreateNewRuleState({
    required this.rule,
    required this.conditions,
    required this.actions,
    required this.forwards,
    required this.replies,
    required this.sends,
    this.operator,
  });

  final Rule rule;
  final List<RuleCondition> conditions;
  final List<RuleAction> actions;
  final bool forwards;
  final bool replies;
  final bool sends;
  final RuleOperator? operator;

  CreateNewRuleState copyWith({
    Rule? rule,
    List<RuleCondition>? conditions,
    List<RuleAction>? actions,
    bool? forwards,
    bool? replies,
    bool? sends,
    RuleOperator? operator,
  }) {
    return CreateNewRuleState(
      rule: rule ?? this.rule,
      conditions: conditions ?? this.conditions,
      actions: actions ?? this.actions,
      forwards: forwards ?? this.forwards,
      replies: replies ?? this.replies,
      sends: sends ?? this.sends,
      operator: operator ?? this.operator,
    );
  }
}
