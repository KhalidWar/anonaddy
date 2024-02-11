import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'username.g.dart';

@JsonSerializable(explicitToJson: true)
class Username {
  Username({
    this.id = '',
    this.userId = '',
    this.username = '',
    this.description = '',
    this.aliases = const <Alias>[],
    this.defaultRecipient,
    this.active = false,
    this.catchAll = false,
    this.createdAt = '',
    this.updatedAt = '',
  });

  String id;

  @JsonKey(name: 'user_id')
  final String userId;

  final String username;

  final String description;

  final List<Alias> aliases;

  @JsonKey(name: 'default_recipient')
  final Recipient? defaultRecipient;

  final bool active;

  @JsonKey(name: 'catch_all')
  final bool catchAll;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  factory Username.fromJson(Map<String, dynamic> json) =>
      _$UsernameFromJson(json);

  Map<String, dynamic> toJson() => _$UsernameToJson(this);

  Username copyWith({
    String? id,
    String? userId,
    String? username,
    String? description,
    List<Alias>? aliases,
    Recipient? defaultRecipient,
    bool? active,
    bool? catchAll,
    String? createdAt,
    String? updatedAt,
  }) {
    return Username(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      description: description ?? this.description,
      aliases: aliases ?? this.aliases,
      defaultRecipient: defaultRecipient ?? this.defaultRecipient,
      active: active ?? this.active,
      catchAll: catchAll ?? this.catchAll,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Username{id: $id, userId: $userId, username: $username, description: $description, aliases: $aliases, defaultRecipient: $defaultRecipient, active: $active, catchAll: $catchAll, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
