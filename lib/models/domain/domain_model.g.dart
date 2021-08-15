// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomainModel _$DomainModelFromJson(Map<String, dynamic> json) {
  return DomainModel(
    domains: (json['data'] as List<dynamic>)
        .map((e) => Domain.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$DomainModelToJson(DomainModel instance) =>
    <String, dynamic>{
      'data': instance.domains.map((e) => e.toJson()).toList(),
    };

Domain _$DomainFromJson(Map<String, dynamic> json) {
  return Domain(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    domain: json['domain'] as String,
    description: json['description'] as String?,
    aliases: (json['aliases'] as List<dynamic>?)
        ?.map((e) => Alias.fromJson(e as Map<String, dynamic>))
        .toList(),
    defaultRecipient: json['default_recipient'] == null
        ? null
        : Recipient.fromJson(json['default_recipient'] as Map<String, dynamic>),
    active: json['active'] as bool,
    catchAll: json['catch_all'] as bool,
    domainVerifiedAt: json['domain_verified_at'] == null
        ? null
        : DateTime.parse(json['domain_verified_at'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  )
    ..domainMxValidatedAt = json['domain_mx_validated_at'] == null
        ? null
        : DateTime.parse(json['domain_mx_validated_at'] as String)
    ..domainSendingVerifiedAt = json['domain_sending_verified_at'] == null
        ? null
        : DateTime.parse(json['domain_sending_verified_at'] as String);
}

Map<String, dynamic> _$DomainToJson(Domain instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'domain': instance.domain,
      'description': instance.description,
      'aliases': instance.aliases?.map((e) => e.toJson()).toList(),
      'default_recipient': instance.defaultRecipient?.toJson(),
      'active': instance.active,
      'catch_all': instance.catchAll,
      'domain_verified_at': instance.domainVerifiedAt?.toIso8601String(),
      'domain_mx_validated_at': instance.domainMxValidatedAt?.toIso8601String(),
      'domain_sending_verified_at':
          instance.domainSendingVerifiedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
