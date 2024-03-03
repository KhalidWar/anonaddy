import 'package:anonaddy/features/recipients/domain/recipient.dart';
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
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
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
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  @HiveField(16)
  final DateTime updatedAt;

  @JsonKey(name: 'deleted_at')
  @HiveField(17)
  final DateTime? deletedAt;

  factory Alias.fromJson(Map<String, dynamic> json) => _$AliasFromJson(json);

  Map<String, dynamic> toJson() => _$AliasToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Alias &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          aliasableId == other.aliasableId &&
          aliasableType == other.aliasableType &&
          localPart == other.localPart &&
          extension == other.extension &&
          domain == other.domain &&
          email == other.email &&
          active == other.active &&
          description == other.description &&
          emailsForwarded == other.emailsForwarded &&
          emailsBlocked == other.emailsBlocked &&
          emailsReplied == other.emailsReplied &&
          emailsSent == other.emailsSent &&
          recipients == other.recipients &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          deletedAt == other.deletedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      aliasableId.hashCode ^
      aliasableType.hashCode ^
      localPart.hashCode ^
      extension.hashCode ^
      domain.hashCode ^
      email.hashCode ^
      active.hashCode ^
      description.hashCode ^
      emailsForwarded.hashCode ^
      emailsBlocked.hashCode ^
      emailsReplied.hashCode ^
      emailsSent.hashCode ^
      recipients.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;

  @override
  String toString() {
    return 'Alias{id: $id, userId: $userId, aliasableId: $aliasableId, aliasableType: $aliasableType, localPart: $localPart, extension: $extension, domain: $domain, email: $email, active: $active, description: $description, emailsForwarded: $emailsForwarded, emailsBlocked: $emailsBlocked, emailsReplied: $emailsReplied, emailsSent: $emailsSent, recipients: $recipients, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}

extension AliasExtension on Alias {
  bool get isDeleted => deletedAt != null;
}
