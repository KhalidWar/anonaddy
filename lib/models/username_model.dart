import 'alias_model.dart';

class UsernameModel {
  const UsernameModel({this.usernameDataList});

  final List<UsernameDataModel> usernameDataList;

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
  const UsernameDataModel({
    this.id,
    this.userId,
    this.username,
    this.description,
    this.aliases,
    // this.defaultRecipient,
    this.active,
    this.catchAll,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String username;
  final String description;
  final List<AliasDataModel> aliases;
  // RecipientDataModel defaultRecipient;
  final bool active;
  final bool catchAll;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory UsernameDataModel.fromJson(Map<String, dynamic> json) {
    List list = json['aliases'];
    List<AliasDataModel> aliasesList =
        list.map((i) => AliasDataModel.fromJson(i)).toList();

    return UsernameDataModel(
      id: json["id"],
      userId: json["user_id"],
      username: json["username"],
      description: json["description"],
      aliases: aliasesList,
      // defaultRecipient: json["default_recipient"],
      active: json["active"],
      catchAll: json["catch_all"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}
