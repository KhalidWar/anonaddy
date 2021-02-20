import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';

class UsernameDataModel {
  const UsernameDataModel({
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

  final String id;
  final String userId;
  final String username;
  final String description;
  final List<AliasDataModel> aliases;
  final RecipientDataModel defaultRecipient;
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
}
