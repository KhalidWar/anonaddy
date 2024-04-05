import 'package:anonaddy/features/rules/domain/rule_action.dart';
import 'package:anonaddy/features/rules/domain/rule_condition.dart';
import 'package:json_annotation/json_annotation.dart';

enum RuleOperator { and, or }

class Rule {
  const Rule({
    required this.id,
    required this.userId,
    required this.name,
    required this.order,
    required this.active,
    required this.conditions,
    required this.actions,
    required this.operator,
    required this.forwards,
    required this.replies,
    required this.sends,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  final int order;
  final bool active;
  final List<RuleCondition> conditions;
  final List<RuleAction> actions;
  final RuleOperator operator;
  final bool forwards;
  final bool replies;
  final bool sends;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      order: json['order'] as int,
      active: json['active'] as bool,
      conditions: (json['conditions'] as List)
          .map((e) => RuleCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      actions: (json['actions'] as List)
          .map((e) => RuleAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      operator: RuleOperator.values.firstWhere((operator) =>
          operator.name == (json['operator'] as String).toLowerCase()),
      forwards: json['forwards'] as bool,
      replies: json['replies'] as bool,
      sends: json['sends'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  String toString() {
    return 'Rule{id: $id, userId: $userId, name: $name, order: $order, active: $active, conditions: $conditions, actions: $actions, operator: $operator, forwards: $forwards, replies: $replies, sends: $sends, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
