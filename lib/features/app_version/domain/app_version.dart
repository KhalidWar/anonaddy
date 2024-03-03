import 'package:json_annotation/json_annotation.dart';

part 'app_version.g.dart';

@JsonSerializable()
class AppVersion {
  AppVersion(this.version, this.major, this.minor, this.patch);

  String version;
  int major, minor, patch;

  factory AppVersion.fromJson(Map<String, dynamic> json) =>
      _$AppVersionFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionToJson(this);

  @override
  String toString() {
    return 'AppVersion{version: $version, major: $major, minor: $minor, patch: $patch}';
  }
}
