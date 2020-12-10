class UsernameModel {
  UsernameModel({
    this.usernameDataList,
  });

  List<UsernameDataModel> usernameDataList;

  factory UsernameModel.fromJson(Map<String, dynamic> json) {
    List list = json['data'];
    List<UsernameDataModel> usernameDataList =
        list.map((i) => UsernameDataModel.fromJson(i)).toList();

    return UsernameModel(
      usernameDataList: usernameDataList,
    );
  }
}

class UsernameDataModel {
  UsernameDataModel({
    this.id,
    this.userId,
    this.username,
    this.description,
    this.aliases,
    this.defaultRecipient,
    this.active,
    this.catchAll,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String userId;
  String username;
  dynamic description;
  List<dynamic> aliases;
  dynamic defaultRecipient;
  bool active;
  bool catchAll;
  DateTime createdAt;
  DateTime updatedAt;

  factory UsernameDataModel.fromJson(Map<String, dynamic> json) =>
      UsernameDataModel(
        id: json["id"],
        userId: json["user_id"],
        username: json["username"],
        description: json["description"],
        aliases: List<dynamic>.from(json["aliases"].map((x) => x)),
        defaultRecipient: json["default_recipient"],
        active: json["active"],
        catchAll: json["catch_all"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "username": username,
        "description": description,
        "aliases": List<dynamic>.from(aliases.map((x) => x)),
        "default_recipient": defaultRecipient,
        "active": active,
        "catch_all": catchAll,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
