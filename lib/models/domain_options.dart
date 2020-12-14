class DomainOptions {
  const DomainOptions({
    this.data,
    this.defaultAliasDomain,
    this.defaultAliasFormat,
  });

  final List<String> data;
  final String defaultAliasDomain;
  final String defaultAliasFormat;

  factory DomainOptions.fromJson(Map<String, dynamic> json) {
    return DomainOptions(
      data: List<String>.from(json["data"].map((x) => x)),
      defaultAliasDomain: json["defaultAliasDomain"],
      defaultAliasFormat: json["defaultAliasFormat"],
    );
  }
}
