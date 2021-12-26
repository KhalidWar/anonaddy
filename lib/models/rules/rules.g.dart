// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rules.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rules _$RulesFromJson(Map<String, dynamic> json) {
  return Rules(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    name: json['name'] as String,
    order: json['order'] as int,
    active: json['active'] as bool,
    operator: json['operator'] as String,
    forwards: json['forwards'] as bool,
    replies: json['replies'] as bool,
    sends: json['sends'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$RulesToJson(Rules instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'order': instance.order,
      'active': instance.active,
      'operator': instance.operator,
      'forwards': instance.forwards,
      'replies': instance.replies,
      'sends': instance.sends,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
