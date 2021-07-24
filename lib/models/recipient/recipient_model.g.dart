// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipientModel _$RecipientModelFromJson(Map<String, dynamic> json) {
  return RecipientModel(
    recipients: (json['data'] as List<dynamic>)
        .map((e) => Recipient.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$RecipientModelToJson(RecipientModel instance) =>
    <String, dynamic>{
      'data': instance.recipients.map((e) => e.toJson()).toList(),
    };

Recipient _$RecipientFromJson(Map<String, dynamic> json) {
  return Recipient(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    email: json['email'] as String,
    shouldEncrypt: json['should_encrypt'] as bool,
    fingerprint: json['fingerprint'] as String?,
    emailVerifiedAt: json['email_verified_at'] == null
        ? null
        : DateTime.parse(json['email_verified_at'] as String),
    aliases: (json['aliases'] as List<dynamic>?)
        ?.map((e) => Alias.fromJson(e as Map<String, dynamic>))
        .toList(),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

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
    };
