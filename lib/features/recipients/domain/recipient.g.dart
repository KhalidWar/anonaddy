// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipient _$RecipientFromJson(Map<String, dynamic> json) => Recipient(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      email: json['email'] as String,
      canReplySend: json['can_reply_send'] as bool,
      shouldEncrypt: json['should_encrypt'] as bool,
      inlineEncryption: json['inline_encryption'] as bool,
      protectedHeaders: json['protected_headers'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      aliasesCount: json['aliases_count'] as int?,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      fingerprint: json['fingerprint'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
          ?.map((e) => Alias.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecipientToJson(Recipient instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'email': instance.email,
      'should_encrypt': instance.shouldEncrypt,
      'fingerprint': instance.fingerprint,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'aliases': instance.aliases?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'can_reply_send': instance.canReplySend,
      'inline_encryption': instance.inlineEncryption,
      'protected_headers': instance.protectedHeaders,
      'aliases_count': instance.aliasesCount,
    };
