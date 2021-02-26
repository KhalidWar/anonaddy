import 'package:anonaddy/models/recipient/recipient_data_model.dart';

class AliasDataModel {
  AliasDataModel({
    this.aliasID,
    this.userId,
    this.aliasableId,
    this.aliasableType,
    this.localPart,
    this.extension,
    this.domain,
    this.email,
    this.isAliasActive,
    this.emailDescription,
    this.emailsForwarded,
    this.emailsBlocked,
    this.emailsReplied,
    this.emailsSent,
    this.recipients,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String aliasID;
  final String userId;
  final dynamic aliasableId;
  final dynamic aliasableType;
  final String localPart;
  final dynamic extension;
  final String domain;
  final String email;
  final bool isAliasActive;
  String emailDescription;
  final int emailsForwarded;
  final int emailsBlocked;
  final int emailsReplied;
  final int emailsSent;
  final List<RecipientDataModel> recipients;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  factory AliasDataModel.fromJson(Map<String, dynamic> json) {
    return AliasDataModel(
      aliasID: json["id"],
      userId: json["user_id"],
      aliasableId: json["aliasable_id"],
      aliasableType: json["aliasable_type"],
      localPart: json["local_part"],
      extension: json["extension"],
      domain: json["domain"],
      email: json["email"],
      isAliasActive: json["active"],
      emailDescription: json["description"] ?? 'No Description',
      emailsForwarded: json["emails_forwarded"],
      emailsBlocked: json["emails_blocked"],
      emailsReplied: json["emails_replied"],
      emailsSent: json["emails_sent"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      deletedAt: json["deleted_at"] == null
          ? null
          : DateTime.parse(json["deleted_at"]),
    );
  }

  factory AliasDataModel.fromJsonAliasData(Map<String, dynamic> json) {
    List list = json['recipients'];
    List<RecipientDataModel> recipientList = list
        .map((i) => RecipientDataModel.fromJsonRecipientNoAliases(i))
        .toList();

    return AliasDataModel(
      aliasID: json["id"],
      userId: json["user_id"],
      aliasableId: json["aliasable_id"],
      aliasableType: json["aliasable_type"],
      localPart: json["local_part"],
      extension: json["extension"],
      domain: json["domain"],
      email: json["email"],
      isAliasActive: json["active"],
      emailDescription: json["description"] ?? 'No Description',
      emailsForwarded: json["emails_forwarded"],
      emailsBlocked: json["emails_blocked"],
      emailsReplied: json["emails_replied"],
      emailsSent: json["emails_sent"],
      recipients: recipientList,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      deletedAt: json["deleted_at"] == null
          ? null
          : DateTime.parse(json["deleted_at"]),
    );
  }

  factory AliasDataModel.fromJsonData(Map<String, dynamic> json) {
    return AliasDataModel(
      aliasID: json['data']["id"],
      userId: json['data']["user_id"],
      aliasableId: json['data']["aliasable_id"],
      aliasableType: json['data']["aliasable_type"],
      localPart: json['data']["local_part"],
      extension: json['data']["extension"],
      domain: json['data']["domain"],
      email: json['data']["email"],
      isAliasActive: json['data']["active"],
      emailDescription: json['data']["description"] ?? 'No Description',
      emailsForwarded: json['data']["emails_forwarded"],
      emailsBlocked: json['data']["emails_blocked"],
      emailsReplied: json['data']["emails_replied"],
      emailsSent: json['data']["emails_sent"],
      createdAt: DateTime.parse(json['data']["created_at"]),
      updatedAt: DateTime.parse(json['data']["updated_at"]),
      deletedAt: json["deleted_at"] == null
          ? null
          : DateTime.parse(json['data']["deleted_at"]),
    );
  }
}
