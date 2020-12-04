class AliasDataModel {
  const AliasDataModel({
    this.aliasID,
    this.userId,
    this.aliasableId,
    this.aliasableType,
    this.localPart,
    this.extension,
    // this.domain,
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
  // final Domain domain;
  final String email;
  final bool isAliasActive;
  final String emailDescription;
  final int emailsForwarded;
  final int emailsBlocked;
  final int emailsReplied;
  final int emailsSent;
  final List<dynamic> recipients;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  factory AliasDataModel.fromJson(Map<String, dynamic> json) {
    return AliasDataModel(
      aliasID: json["id"],
      userId: json["user_id"],
      aliasableId: json["aliasable_id"],
      aliasableType: json["aliasable_type"],
      localPart: json["local_part"],
      extension: json["extension"],
      // domain: domainValues.map[json["domain"]],
      email: json["email"],
      isAliasActive: json["active"],
      emailDescription: json["description"] ?? 'No Description',
      emailsForwarded: json["emails_forwarded"],
      emailsBlocked: json["emails_blocked"],
      emailsReplied: json["emails_replied"],
      emailsSent: json["emails_sent"],
      recipients: List<dynamic>.from(json["recipients"].map((x) => x)),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      deletedAt: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": aliasID,
        "user_id": userId,
        "aliasable_id": aliasableId,
        "aliasable_type": aliasableType,
        "local_part": localPart,
        "extension": extension,
        // "domain": domainValues.reverse[domain],
        "email": email,
        "active": isAliasActive,
        "description": emailDescription,
        "emails_forwarded": emailsForwarded,
        "emails_blocked": emailsBlocked,
        "emails_replied": emailsReplied,
        "emails_sent": emailsSent,
        "recipients": List<dynamic>.from(recipients.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
