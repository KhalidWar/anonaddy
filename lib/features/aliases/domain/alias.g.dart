// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alias.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alias _$AliasFromJson(Map<String, dynamic> json) => Alias(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      aliasableId: json['aliasable_id'] as String? ?? '',
      aliasableType: json['aliasable_type'] as String? ?? '',
      localPart: json['local_part'] as String? ?? '',
      extension: json['extension'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      email: json['email'] as String? ?? '',
      active: json['active'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      emailsForwarded: json['emails_forwarded'] as int? ?? 0,
      emailsBlocked: json['emails_blocked'] as int? ?? 0,
      emailsReplied: json['emails_replied'] as int? ?? 0,
      emailsSent: json['emails_sent'] as int? ?? 0,
      recipients: (json['recipients'] as List<dynamic>?)
              ?.map((e) => Recipient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Recipient>[],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$AliasToJson(Alias instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'aliasable_id': instance.aliasableId,
      'aliasable_type': instance.aliasableType,
      'local_part': instance.localPart,
      'extension': instance.extension,
      'domain': instance.domain,
      'email': instance.email,
      'active': instance.active,
      'description': instance.description,
      'emails_forwarded': instance.emailsForwarded,
      'emails_blocked': instance.emailsBlocked,
      'emails_replied': instance.emailsReplied,
      'emails_sent': instance.emailsSent,
      'recipients': instance.recipients.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
