import 'dart:convert';

import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:hive/hive.dart';

part 'alias_data_model.g.dart';

@HiveType(typeId: 0)
class AliasDataModel extends HiveObject {
  AliasDataModel({
    required this.aliasID,
    this.userId,
    this.aliasableId,
    this.aliasableType,
    this.localPart,
    this.extension,
    this.domain,
    this.email,
    required this.isAliasActive,
    this.emailDescription,
    required this.emailsForwarded,
    required this.emailsBlocked,
    required this.emailsReplied,
    required this.emailsSent,
    this.recipients,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @HiveField(0)
  String aliasID;
  @HiveField(1)
  String? userId;
  @HiveField(2)
  dynamic aliasableId;
  @HiveField(3)
  dynamic aliasableType;
  @HiveField(4)
  String? localPart;
  @HiveField(5)
  dynamic extension;
  @HiveField(6)
  String? domain;
  @HiveField(7)
  String? email;
  @HiveField(8)
  bool isAliasActive;
  @HiveField(9)
  String? emailDescription;
  @HiveField(10)
  int emailsForwarded;
  @HiveField(11)
  int emailsBlocked;
  @HiveField(12)
  int emailsReplied;
  @HiveField(13)
  int emailsSent;
  @HiveField(14)
  List<RecipientDataModel>? recipients;
  @HiveField(15)
  DateTime? createdAt;
  @HiveField(16)
  DateTime? updatedAt;
  @HiveField(17)
  DateTime? deletedAt;

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
    List list = json["data"]['recipients'];
    List<RecipientDataModel> recipientList = list
        .map((i) => RecipientDataModel.fromJsonRecipientNoAliases(i))
        .toList();

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
      recipients: recipientList,
      createdAt: DateTime.parse(json['data']["created_at"]),
      updatedAt: DateTime.parse(json['data']["updated_at"]),
      deletedAt: json["deleted_at"] == null
          ? null
          : DateTime.parse(json['data']["deleted_at"]),
    );
  }

  static String encode(List<AliasDataModel> aliasList) {
    return json.encode(
      aliasList
          .map<Map<String, dynamic>>((alias) => AliasDataModel.toMap(alias))
          .toList(),
    );
  }

  static List<AliasDataModel> decode(String encodedData) {
    return (json.decode(encodedData) as List<dynamic>)
        .map<AliasDataModel>((item) => AliasDataModel.fromJson(item))
        .toList();
  }

  static Map<String, dynamic> toMap(AliasDataModel alias) {
    return {
      "id": alias.aliasID,
      "user_id": alias.userId,
      "aliasable_id": alias.aliasableId,
      "aliasable_type": alias.aliasableType,
      "local_part": alias.localPart,
      "extension": alias.extension,
      "domain": alias.domain,
      "email": alias.email,
      "active": alias.isAliasActive,
      "description": alias.emailDescription,
      "emails_forwarded": alias.emailsForwarded,
      "emails_blocked": alias.emailsBlocked,
      "emails_replied": alias.emailsReplied,
      "emails_sent": alias.emailsSent,
      // "recipients": List<dynamic>.from(recipients.map((x) => x)),
      "created_at": alias.createdAt!.toIso8601String(),
      "updated_at": alias.updatedAt!.toIso8601String(),
    };
  }
}
