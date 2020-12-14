class AppVersion {
  const AppVersion({
    this.version,
    this.major,
    this.minor,
    this.patch,
  });

  final String version;
  final int major;
  final int minor;
  final int patch;

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      version: json["version"],
      major: json["major"],
      minor: json["minor"],
      patch: json["patch"],
    );
  }
}
