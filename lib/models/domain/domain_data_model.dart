class DomainDataModel {
  const DomainDataModel({
    this.id,
    this.userId,
    this.domain,
    this.description,
    this.aliases,
    this.defaultRecipient,
    this.active,
    this.catchAll,
    this.domainVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String domain;
  final dynamic description;
  final List<dynamic> aliases;
  final dynamic defaultRecipient;
  final bool active;
  final bool catchAll;
  final DateTime domainVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory DomainDataModel.fromJson(Map<String, dynamic> json) {
    return DomainDataModel(
      id: json["id"],
      userId: json["user_id"],
      domain: json["domain"],
      description: json["description"],
      aliases: List<dynamic>.from(json["aliases"].map((x) => x)),
      defaultRecipient: json["default_recipient"],
      active: json["active"],
      catchAll: json["catch_all"],
      domainVerifiedAt: json["domain_verified_at"] == null
          ? null
          : DateTime.parse(json["domain_verified_at"]),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}
