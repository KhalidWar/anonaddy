// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'username.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Username _$UsernameFromJson(Map<String, dynamic> json) => Username(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      description: json['description'] as String? ?? '',
      aliases: (json['aliases'] as List<dynamic>?)
              ?.map((e) => Alias.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Alias>[],
      defaultRecipient: json['default_recipient'] == null
          ? null
          : Recipient.fromJson(
              json['default_recipient'] as Map<String, dynamic>),
      active: json['active'] as bool? ?? false,
      catchAll: json['catch_all'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UsernameToJson(Username instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'username': instance.username,
      'description': instance.description,
      'aliases': instance.aliases.map((e) => e.toJson()).toList(),
      'default_recipient': instance.defaultRecipient?.toJson(),
      'active': instance.active,
      'catch_all': instance.catchAll,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
