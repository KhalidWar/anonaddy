import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'domain_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DomainModel {
  const DomainModel({required this.domains});

  @JsonKey(name: 'data')
  final List<Domain> domains;

  factory DomainModel.fromJson(Map<String, dynamic> json) =>
      _$DomainModelFromJson(json);

  Map<String, dynamic> toJson() => _$DomainModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Domain {
  Domain({
    required this.id,
    required this.userId,
    required this.domain,
    this.description,
    required this.aliases,
    this.defaultRecipient,
    required this.active,
    required this.catchAll,
    this.domainVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;

  @JsonKey(name: 'user_id')
  String userId;

  String domain;
  String? description;
  List<Alias>? aliases;

  @JsonKey(name: 'default_recipient')
  Recipient? defaultRecipient;
  bool active;

  @JsonKey(name: 'catch_all')
  bool catchAll;

  @JsonKey(name: 'domain_verified_at')
  DateTime? domainVerifiedAt;

  @JsonKey(name: 'domain_mx_validated_at')
  DateTime? domainMxValidatedAt;

  @JsonKey(name: 'domain_sending_verified_at')
  DateTime? domainSendingVerifiedAt;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  factory Domain.fromJson(Map<String, dynamic> json) => _$DomainFromJson(json);

  Map<String, dynamic> toJson() => _$DomainToJson(this);
}
