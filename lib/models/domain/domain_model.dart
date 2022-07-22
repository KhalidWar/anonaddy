import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'domain_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Domain {
  Domain({
    this.id = '',
    this.userId = '',
    this.domain = '',
    this.description = '',
    this.aliases = const <Alias>[],
    this.defaultRecipient,
    this.active = false,
    this.catchAll = false,
    this.domainVerifiedAt = '',
    this.domainMxValidatedAt = '',
    this.domainSendingVerifiedAt = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  String id;

  @JsonKey(name: 'user_id')
  final String userId;

  final String domain;
  final String description;
  final List<Alias> aliases;

  @JsonKey(name: 'default_recipient')
  final Recipient? defaultRecipient;
  final bool active;

  @JsonKey(name: 'catch_all')
  final bool catchAll;

  @JsonKey(name: 'domain_verified_at')
  final String domainVerifiedAt;

  @JsonKey(name: 'domain_mx_validated_at')
  final String domainMxValidatedAt;

  @JsonKey(name: 'domain_sending_verified_at')
  final String domainSendingVerifiedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  factory Domain.fromJson(Map<String, dynamic> json) => _$DomainFromJson(json);

  Map<String, dynamic> toJson() => _$DomainToJson(this);

  Domain copyWith({
    String? id,
    String? userId,
    String? domain,
    String? description,
    List<Alias>? aliases,
    Recipient? defaultRecipient,
    bool? active,
    bool? catchAll,
    String? domainVerifiedAt,
    String? domainMxValidatedAt,
    String? domainSendingVerifiedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return Domain(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      domain: domain ?? this.domain,
      description: description ?? this.description,
      aliases: aliases ?? this.aliases,
      defaultRecipient: defaultRecipient ?? this.defaultRecipient,
      active: active ?? this.active,
      catchAll: catchAll ?? this.catchAll,
      domainVerifiedAt: domainVerifiedAt ?? this.domainVerifiedAt,
      domainMxValidatedAt: domainMxValidatedAt ?? this.domainMxValidatedAt,
      domainSendingVerifiedAt:
          domainSendingVerifiedAt ?? this.domainSendingVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Domain{id: $id, userId: $userId, domain: $domain, description: $description, aliases: $aliases, defaultRecipient: $defaultRecipient, active: $active, catchAll: $catchAll, domainVerifiedAt: $domainVerifiedAt, domainMxValidatedAt: $domainMxValidatedAt, domainSendingVerifiedAt: $domainSendingVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
