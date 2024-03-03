// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomainOptions _$DomainOptionsFromJson(Map<String, dynamic> json) =>
    DomainOptions(
      domains: (json['data'] as List<dynamic>).map((e) => e as String).toList(),
      sharedDomains: (json['sharedDomains'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      defaultAliasDomain: json['defaultAliasDomain'] as String?,
      defaultAliasFormat: json['defaultAliasFormat'] as String?,
    );

Map<String, dynamic> _$DomainOptionsToJson(DomainOptions instance) =>
    <String, dynamic>{
      'data': instance.domains,
      'sharedDomains': instance.sharedDomains,
      'defaultAliasDomain': instance.defaultAliasDomain,
      'defaultAliasFormat': instance.defaultAliasFormat,
    };
