import 'package:json_annotation/json_annotation.dart';

part 'app_version_model.g.dart';

@JsonSerializable()
class AppVersion {
  AppVersion(this.version, this.major, this.minor, this.patch);

  String version;
  int major, minor, patch;

  factory AppVersion.fromJson(Map<String, dynamic> json) =>
      _$AppVersionFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionToJson(this);
}
