class AppVersion {
  AppVersion({
    this.version,
    this.major,
    this.minor,
    this.patch,
  });

  String version;
  int major;
  int minor;
  int patch;

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      version: json["version"],
      major: json["major"],
      minor: json["minor"],
      patch: json["patch"],
    );
  }

  Map<String, dynamic> toJson() => {
        "version": version,
        "major": major,
        "minor": minor,
        "patch": patch,
      };
}
