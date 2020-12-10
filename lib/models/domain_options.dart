class DomainOptions {
  DomainOptions({
    this.data,
    this.defaultAliasDomain,
    this.defaultAliasFormat,
  });

  List<String> data;
  String defaultAliasDomain;
  String defaultAliasFormat;

  factory DomainOptions.fromJson(Map<String, dynamic> json) {
    return DomainOptions(
      data: List<String>.from(json["data"].map((x) => x)),
      defaultAliasDomain: json["defaultAliasDomain"],
      defaultAliasFormat: json["defaultAliasFormat"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
        "defaultAliasDomain": defaultAliasDomain,
        "defaultAliasFormat": defaultAliasFormat,
      };
}
