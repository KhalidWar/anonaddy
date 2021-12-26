import 'package:json_annotation/json_annotation.dart';

part 'rules.g.dart';

@JsonSerializable()
class Rules {
  Rules({
    required this.id,
    required this.userId,
    required this.name,
    required this.order,
    required this.active,
    required this.operator,
    required this.forwards,
    required this.replies,
    required this.sends,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;

  @JsonKey(name: 'user_id')
  String userId;

  String name;
  int order;

  bool active;
  String operator;
  bool forwards;
  bool replies;
  bool sends;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  factory Rules.fromJson(Map<String, dynamic> json) => _$RulesFromJson(json);

  Map<String, dynamic> toJson() => _$RulesToJson(this);

  String toString() {
    return toJson().toString();
  }
}
