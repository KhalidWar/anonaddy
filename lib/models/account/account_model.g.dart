// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) {
  return AccountModel(
    Account.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'data': instance.account.toJson(),
    };

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account(
    id: json['id'] as String,
    username: json['username'] as String,
    fromName: json['from_name'] as String?,
    emailSubject: json['email_subject'] as String?,
    bannerLocation: json['banner_location'] as String,
    bandwidth: json['bandwidth'] as int,
    bandwidthLimit: json['bandwidth_limit'] as int?,
    usernameCount: json['username_count'] as int?,
    usernameLimit: json['username_limit'] as int?,
    defaultRecipientId: json['default_recipient_id'] as String,
    defaultAliasDomain: json['default_alias_domain'] as String?,
    defaultAliasFormat: json['default_alias_format'] as String?,
    subscription: json['subscription'] as String?,
    subscriptionEndAt: json['subscription_ends_at'] == null
        ? null
        : DateTime.parse(json['subscription_ends_at'] as String),
    recipientCount: json['recipient_count'] as int?,
    recipientLimit: json['recipient_limit'] as int?,
    activeDomainCount: json['active_domain_count'] as int?,
    activeDomainLimit: json['active_domain_limit'] as int?,
    aliasCount: json['active_shared_domain_alias_count'] as int?,
    aliasLimit: json['active_shared_domain_alias_limit'] as int?,
    createdAt: DateTime.parse(json['created_at'] as String),
    lastUpdated: DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'from_name': instance.fromName,
      'email_subject': instance.emailSubject,
      'banner_location': instance.bannerLocation,
      'bandwidth': instance.bandwidth,
      'bandwidth_limit': instance.bandwidthLimit,
      'username_count': instance.usernameCount,
      'username_limit': instance.usernameLimit,
      'default_recipient_id': instance.defaultRecipientId,
      'default_alias_domain': instance.defaultAliasDomain,
      'default_alias_format': instance.defaultAliasFormat,
      'subscription': instance.subscription,
      'subscription_ends_at': instance.subscriptionEndAt?.toIso8601String(),
      'recipient_count': instance.recipientCount,
      'recipient_limit': instance.recipientLimit,
      'active_domain_count': instance.activeDomainCount,
      'active_domain_limit': instance.activeDomainLimit,
      'active_shared_domain_alias_count': instance.aliasCount,
      'active_shared_domain_alias_limit': instance.aliasLimit,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.lastUpdated.toIso8601String(),
    };
