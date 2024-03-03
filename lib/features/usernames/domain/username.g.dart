// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'username.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Username _$UsernameFromJson(Map<String, dynamic> json) => Username(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      catchAll: json['catch_all'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      active: json['active'] as bool,
      description: json['description'] as String?,
      fromName: json['from_name'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
          ?.map((e) => Alias.fromJson(e as Map<String, dynamic>))
          .toList(),
      aliasesCount: json['aliases_count'] as int?,
      defaultRecipient: json['default_recipient'] == null
          ? null
          : Recipient.fromJson(
              json['default_recipient'] as Map<String, dynamic>),
      canLogin: json['can_login'] as bool?,
    );

Map<String, dynamic> _$UsernameToJson(Username instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'username': instance.username,
      'description': instance.description,
      'from_name': instance.fromName,
      'aliases': instance.aliases?.map((e) => e.toJson()).toList(),
      'aliases_count': instance.aliasesCount,
      'default_recipient': instance.defaultRecipient?.toJson(),
      'active': instance.active,
      'catch_all': instance.catchAll,
      'can_login': instance.canLogin,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
