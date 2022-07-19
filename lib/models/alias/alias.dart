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
  String id;

  @JsonKey(name: 'user_id')
  @HiveField(1)
  String userId;

  @JsonKey(name: 'aliasable_id')
  @HiveField(2)
  String aliasableId;

  @JsonKey(name: 'aliasable_type')
  @HiveField(3)
  String aliasableType;

  @JsonKey(name: 'local_part')
  @HiveField(4)
  String localPart;

  @HiveField(5)
  String extension;

  @HiveField(6)
  String domain;

  @HiveField(7)
  String email;

  @HiveField(8)
  bool active;

  @HiveField(9)
  String description;

  @JsonKey(name: 'emails_forwarded')
  @HiveField(10)
  int emailsForwarded;

  @JsonKey(name: 'emails_blocked')
  @HiveField(11)
  int emailsBlocked;

  @JsonKey(name: 'emails_replied')
  @HiveField(12)
  int emailsReplied;

  @JsonKey(name: 'emails_sent')
  @HiveField(13)
  int emailsSent;

  @HiveField(14)
  List<Recipient> recipients;

  @JsonKey(name: 'created_at')
  @HiveField(15)
  String createdAt;

  @JsonKey(name: 'updated_at')
  @HiveField(16)
  String updatedAt;

  @JsonKey(name: 'deleted_at')
  @HiveField(17)
  String deletedAt;

  factory Alias.fromJson(Map<String, dynamic> json) => _$AliasFromJson(json);

  Map<String, dynamic> toJson() => _$AliasToJson(this);

  @override
  String toString() {
    return 'Alias{id: $id, userId: $userId, aliasableId: $aliasableId, aliasableType: $aliasableType, localPart: $localPart, extension: $extension, domain: $domain, email: $email, active: $active, description: $description, emailsForwarded: $emailsForwarded, emailsBlocked: $emailsBlocked, emailsReplied: $emailsReplied, emailsSent: $emailsSent, recipients: $recipients, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}
