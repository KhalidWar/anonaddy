import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/shared_components/constants/hive_type_id.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alias.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypeId.alias)
class Alias extends HiveObject {
  Alias({
    this.id = '',
    this.userId = '',
    this.aliasableId = '',
    this.aliasableType = '',
    this.localPart = '',
    this.extension = '',
    this.domain = '',
    this.email = '',
    this.active = false,
    this.description = '',
    this.emailsForwarded = 0,
    this.emailsBlocked = 0,
    this.emailsReplied = 0,
    this.emailsSent = 0,
    this.recipients = const <Recipient>[],
    this.createdAt = '',
    this.updatedAt = '',
    this.deletedAt = '',
  });

  @HiveField(0)
  final String id;

  @JsonKey(name: 'user_id')
  @HiveField(1)
  final String userId;

  @JsonKey(name: 'aliasable_id')
  @HiveField(2)
  final String aliasableId;

  @JsonKey(name: 'aliasable_type')
  @HiveField(3)
  final String aliasableType;

  @JsonKey(name: 'local_part')
  @HiveField(4)
  final String localPart;

  @HiveField(5)
  final String extension;

  @HiveField(6)
  final String domain;

  @HiveField(7)
  final String email;

  @HiveField(8)
  final bool active;

  @HiveField(9)
  final String description;

  @JsonKey(name: 'emails_forwarded')
  @HiveField(10)
  final int emailsForwarded;

  @JsonKey(name: 'emails_blocked')
  @HiveField(11)
  final int emailsBlocked;

  @JsonKey(name: 'emails_replied')
  @HiveField(12)
  final int emailsReplied;

  @JsonKey(name: 'emails_sent')
  @HiveField(13)
  final int emailsSent;

  @HiveField(14)
  final List<Recipient> recipients;

  @JsonKey(name: 'created_at')
  @HiveField(15)
  final String createdAt;

  @JsonKey(name: 'updated_at')
  @HiveField(16)
  final String updatedAt;

  @JsonKey(name: 'deleted_at')
  @HiveField(17)
  final String deletedAt;

  factory Alias.fromJson(Map<String, dynamic> json) => _$AliasFromJson(json);

  Map<String, dynamic> toJson() => _$AliasToJson(this);

  Alias copyWith({
    String? id,
    String? userId,
    String? aliasableId,
    String? aliasableType,
    String? localPart,
    String? extension,
    String? domain,
    String? email,
    bool? active,
    String? description,
    int? emailsForwarded,
    int? emailsBlocked,
    int? emailsReplied,
    int? emailsSent,
    List<Recipient>? recipients,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return Alias(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      aliasableId: aliasableId ?? this.aliasableId,
      aliasableType: aliasableType ?? this.aliasableType,
      localPart: localPart ?? this.localPart,
      extension: extension ?? this.extension,
      domain: domain ?? this.domain,
      email: email ?? this.email,
      active: active ?? this.active,
      description: description ?? this.description,
      emailsForwarded: emailsForwarded ?? this.emailsForwarded,
      emailsBlocked: emailsBlocked ?? this.emailsBlocked,
      emailsReplied: emailsReplied ?? this.emailsReplied,
      emailsSent: emailsSent ?? this.emailsSent,
      recipients: recipients ?? this.recipients,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  String toString() {
    return 'Alias{id: $id, userId: $userId, aliasableId: $aliasableId, aliasableType: $aliasableType, localPart: $localPart, extension: $extension, domain: $domain, email: $email, active: $active, description: $description, emailsForwarded: $emailsForwarded, emailsBlocked: $emailsBlocked, emailsReplied: $emailsReplied, emailsSent: $emailsSent, recipients: $recipients, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}
