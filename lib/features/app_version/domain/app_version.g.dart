// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersion _$AppVersionFromJson(Map<String, dynamic> json) => AppVersion(
      json['version'] as String,
      json['major'] as int,
      json['minor'] as int,
      json['patch'] as int,
    );

Map<String, dynamic> _$AppVersionToJson(AppVersion instance) =>
    <String, dynamic>{
      'version': instance.version,
      'major': instance.major,
      'minor': instance.minor,
      'patch': instance.patch,
    };
