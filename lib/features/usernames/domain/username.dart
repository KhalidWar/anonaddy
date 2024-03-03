import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'username.g.dart';

@JsonSerializable(explicitToJson: true)
class Username {
  const Username({
    required this.id,
    required this.userId,
    required this.username,
    required this.catchAll,
    required this.createdAt,
    required this.updatedAt,
    required this.active,
    this.description,
    this.fromName,
    this.aliases,
    this.aliasesCount,
    this.defaultRecipient,
    this.canLogin,
  });

  final String id;

  @JsonKey(name: 'user_id')
  final String userId;
  final String username;
  final String? description;

  @JsonKey(name: 'from_name')
  final String? fromName;

  final List<Alias>? aliases;

  @JsonKey(name: 'aliases_count')
  final int? aliasesCount;

  @JsonKey(name: 'default_recipient')
  final Recipient? defaultRecipient;

  final bool active;

  @JsonKey(name: 'catch_all')
  final bool catchAll;

  @JsonKey(name: 'can_login')
  final bool? canLogin;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  factory Username.fromJson(Map<String, dynamic> json) =>
      _$UsernameFromJson(json);

  Map<String, dynamic> toJson() => _$UsernameToJson(this);

  Username copyWith({
    String? id,
    String? userId,
    String? username,
    String? description,
    String? fromName,
    List<Alias>? aliases,
    int? aliasesCount,
    Recipient? defaultRecipient,
    bool? active,
    bool? catchAll,
    bool? canLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Username(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      description: description ?? this.description,
      fromName: fromName ?? this.fromName,
      aliases: aliases ?? this.aliases,
      aliasesCount: aliasesCount ?? this.aliasesCount,
      defaultRecipient: defaultRecipient ?? this.defaultRecipient,
      active: active ?? this.active,
      catchAll: catchAll ?? this.catchAll,
      canLogin: canLogin ?? this.canLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Username{id: $id, userId: $userId, username: $username, description: $description, fromName: $fromName, aliases: $aliases, aliasesCount: $aliasesCount, defaultRecipient: $defaultRecipient, active: $active, catchAll: $catchAll, canLogin: $canLogin, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
