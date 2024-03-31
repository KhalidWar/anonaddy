import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alias.g.dart';

@JsonSerializable(explicitToJson: true)
class Alias {
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

  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'aliasable_id')
  final String aliasableId;

  @JsonKey(name: 'aliasable_type')
  final String aliasableType;

  @JsonKey(name: 'local_part')
  final String localPart;

  final String extension;

  final String domain;

  final String email;

  final bool active;

  final String description;

  @JsonKey(name: 'emails_forwarded')
  final int emailsForwarded;

  @JsonKey(name: 'emails_blocked')
  final int emailsBlocked;

  @JsonKey(name: 'emails_replied')
  final int emailsReplied;

  @JsonKey(name: 'emails_sent')
  final int emailsSent;

  final List<Recipient> recipients;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'deleted_at')
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
