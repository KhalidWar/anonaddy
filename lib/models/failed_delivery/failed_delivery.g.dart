// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failed_delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FailedDelivery _$FailedDeliveryFromJson(Map<String, dynamic> json) =>
    FailedDelivery(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      recipientId: json['recipient_id'] as String?,
      recipientEmail: json['recipient_email'] as String?,
      aliasId: json['alias_id'] as String,
      aliasEmail: json['alias_email'] as String,
      bounceType: json['bounce_type'] as String,
      remoteMta: json['remote_mta'] as String,
      sender: json['sender'] as String?,
      emailType: json['email_type'] as String,
      status: json['status'] as String,
      code: json['code'] as String,
      attemptedAt: DateTime.parse(json['attempted_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FailedDeliveryToJson(FailedDelivery instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'recipient_id': instance.recipientId,
      'recipient_email': instance.recipientEmail,
      'alias_id': instance.aliasId,
      'alias_email': instance.aliasEmail,
      'bounce_type': instance.bounceType,
      'remote_mta': instance.remoteMta,
      'sender': instance.sender,
      'email_type': instance.emailType,
      'status': instance.status,
      'code': instance.code,
      'attempted_at': instance.attemptedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
