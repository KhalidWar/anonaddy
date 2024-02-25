// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Domain _$DomainFromJson(Map<String, dynamic> json) => Domain(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
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
      domainVerifiedAt: json['domain_verified_at'] as String? ?? '',
      domainMxValidatedAt: json['domain_mx_validated_at'] as String? ?? '',
      domainSendingVerifiedAt:
          json['domain_sending_verified_at'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DomainToJson(Domain instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'domain': instance.domain,
      'description': instance.description,
      'aliases': instance.aliases.map((e) => e.toJson()).toList(),
      'default_recipient': instance.defaultRecipient?.toJson(),
      'active': instance.active,
      'catch_all': instance.catchAll,
      'domain_verified_at': instance.domainVerifiedAt,
      'domain_mx_validated_at': instance.domainMxValidatedAt,
      'domain_sending_verified_at': instance.domainSendingVerifiedAt,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
