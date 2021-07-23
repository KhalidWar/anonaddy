class DomainOptions {
  const DomainOptions({
    required this.sharedDomainsList,
    this.defaultAliasDomain,
    this.defaultAliasFormat,
  });

  final List<String> sharedDomainsList;
  final String? defaultAliasDomain;
  final String? defaultAliasFormat;

  factory DomainOptions.fromJson(Map<String, dynamic> json) {
    return DomainOptions(
      sharedDomainsList: List<String>.from(json["data"].map((x) => x)),
      defaultAliasDomain: json["defaultAliasDomain"],
      defaultAliasFormat: json["defaultAliasFormat"],
    );
  }
}
