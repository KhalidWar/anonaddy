import 'package:json_annotation/json_annotation.dart';

part 'domain_options.g.dart';

@JsonSerializable(explicitToJson: true)
class DomainOptions {
  const DomainOptions({
    required this.domains,
    required this.sharedDomains,
    this.defaultAliasDomain,
    this.defaultAliasFormat,
  });

  @JsonKey(name: 'data')
  final List<String> domains;
  final List<String> sharedDomains;
  final String? defaultAliasDomain;
  final String? defaultAliasFormat;

  factory DomainOptions.fromJson(Map<String, dynamic> json) =>
      _$DomainOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$DomainOptionsToJson(this);

  @override
  String toString() {
    return 'DomainOptions{domains: $domains, defaultAliasDomain: $defaultAliasDomain, defaultAliasFormat: $defaultAliasFormat}';
  }
}
