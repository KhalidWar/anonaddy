import 'package:json_annotation/json_annotation.dart';

part 'domain_options.g.dart';

@JsonSerializable(explicitToJson: true)
class DomainOptions {
  DomainOptions({
    required this.domains,
    this.defaultAliasDomain,
    this.defaultAliasFormat,
  });

  @JsonKey(name: 'data')
  List<String> domains;
  String? defaultAliasDomain;
  String? defaultAliasFormat;

  factory DomainOptions.fromJson(Map<String, dynamic> json) =>
      _$DomainOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$DomainOptionsToJson(this);
}
