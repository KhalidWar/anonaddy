import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'domain.g.dart';

@JsonSerializable(explicitToJson: true)
class Domain {
  const Domain({
    required this.id,
    required this.userId,
    required this.domain,
    required this.aliasCount,
    required this.active,
    required this.catchAll,
    required this.createdAt,
    required this.updatedAt,
    this.domainVerifiedAt,
    this.domainMxValidatedAt,
    this.domainSendingVerifiedAt,
    this.defaultRecipient,
    this.aliases,
    this.description,
    this.fromName,
  });

  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  final String domain;
  final String? description;

  @JsonKey(name: 'from_name')
  final String? fromName;
  final List<Alias>? aliases;

  @JsonKey(name: 'aliases_count')
  final int? aliasCount;

  @JsonKey(name: 'default_recipient')
  final Recipient? defaultRecipient;
  final bool active;

  @JsonKey(name: 'catch_all')
  final bool catchAll;

  @JsonKey(name: 'domain_verified_at')
  final DateTime? domainVerifiedAt;

  @JsonKey(name: 'domain_mx_validated_at')
  final DateTime? domainMxValidatedAt;

  @JsonKey(name: 'domain_sending_verified_at')
  final DateTime? domainSendingVerifiedAt;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  factory Domain.fromJson(Map<String, dynamic> json) => _$DomainFromJson(json);

  Map<String, dynamic> toJson() => _$DomainToJson(this);

  Domain copyWith({
    String? id,
    String? userId,
    String? domain,
    String? description,
    String? fromName,
    List<Alias>? aliases,
    int? aliasCount,
    Recipient? defaultRecipient,
    bool? active,
    bool? catchAll,
    DateTime? domainVerifiedAt,
    DateTime? domainMxValidatedAt,
    DateTime? domainSendingVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Domain(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      domain: domain ?? this.domain,
      description: description ?? this.description,
      fromName: fromName ?? this.fromName,
      aliases: aliases ?? this.aliases,
      aliasCount: aliasCount ?? this.aliasCount,
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
    return 'Domain{id: $id, userId: $userId, domain: $domain, description: $description, fromName: $fromName, aliases: $aliases, aliasCount: $aliasCount, defaultRecipient: $defaultRecipient, active: $active, catchAll: $catchAll, domainVerifiedAt: $domainVerifiedAt, domainMxValidatedAt: $domainMxValidatedAt, domainSendingVerifiedAt: $domainSendingVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

extension RecipientExtension on Domain {
  bool get hasDescription => description != null && description!.isNotEmpty;
  bool get isVerified => domainVerifiedAt != null;
  bool get isMXValidated => domainMxValidatedAt != null;
}
