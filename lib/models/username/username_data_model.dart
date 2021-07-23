import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';

class UsernameDataModel {
  UsernameDataModel({
    this.id,
    this.userId,
    required this.username,
    this.description,
    this.aliases,
    this.defaultRecipient,
    this.active,
    this.catchAll,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String username;
  String? description;
  final List<AliasDataModel>? aliases;
  RecipientDataModel? defaultRecipient;
  bool? active;
  bool? catchAll;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
      defaultRecipient: json["default_recipient"] == null
          ? null
          : RecipientDataModel.fromJsonRecipientNoAliases(
              json["default_recipient"]),
      active: json["active"],
      catchAll: json["catch_all"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  factory UsernameDataModel.fromJsonData(Map<String, dynamic> json) {
    return UsernameDataModel(
      id: json['data']["id"],
      userId: json['data']["user_id"],
      username: json['data']["username"],
      description: json['data']["description"],
      defaultRecipient: json['data']["default_recipient"] == null
          ? null
          : RecipientDataModel.fromJsonRecipientNoAliases(
              json['data']["default_recipient"]),
      active: json['data']["active"],
      catchAll: json['data']["catch_all"],
      createdAt: DateTime.parse(json['data']["created_at"]),
      updatedAt: DateTime.parse(json['data']["updated_at"]),
    );
  }
}
