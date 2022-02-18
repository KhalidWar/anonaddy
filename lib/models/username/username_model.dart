import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'username_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UsernameModel {
  UsernameModel({required this.usernames});

  @JsonKey(name: 'data')
  List<Username> usernames;

  factory UsernameModel.fromJson(Map<String, dynamic> json) =>
      _$UsernameModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsernameModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Username {
  Username({
    required this.id,
    required this.userId,
    required this.username,
    this.description,
    required this.aliases,
    this.defaultRecipient,
    required this.active,
    required this.catchAll,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  @JsonKey(name: 'user_id')
  String userId;
  String username;
  String? description;
  List<Alias>? aliases;
  @JsonKey(name: 'default_recipient')
  Recipient? defaultRecipient;
  bool active;
  @JsonKey(name: 'catch_all')
  bool catchAll;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  factory Username.fromJson(Map<String, dynamic> json) =>
      _$UsernameFromJson(json);

  Map<String, dynamic> toJson() => _$UsernameToJson(this);

  @override
  String toString() {
    return 'Username{id: $id, userId: $userId, username: $username, description: $description, aliases: $aliases, defaultRecipient: $defaultRecipient, active: $active, catchAll: $catchAll, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
