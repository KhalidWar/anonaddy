class DomainModel {
  DomainModel({
    this.domainDataList,
  });

  List<DomainDataModel> domainDataList;

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    List list = json['data'];
    List<DomainDataModel> aliasDataList =
        list.map((i) => DomainDataModel.fromJson(i)).toList();

    return DomainModel(
      domainDataList: aliasDataList,
    );
  }
}

class DomainDataModel {
  DomainDataModel({
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

  String id;
  String userId;
  String domain;
  dynamic description;
  List<dynamic> aliases;
  dynamic defaultRecipient;
  bool active;
  bool catchAll;
  DateTime domainVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory DomainDataModel.fromJson(Map<String, dynamic> json) =>
      DomainDataModel(
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "domain": domain,
        "description": description,
        "aliases": List<dynamic>.from(aliases.map((x) => x)),
        "default_recipient": defaultRecipient,
        "active": active,
        "catch_all": catchAll,
        "domain_verified_at": domainVerifiedAt == null
            ? null
            : domainVerifiedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
