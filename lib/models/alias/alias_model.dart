import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alias_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AliasModel {
  AliasModel({required this.aliases});

  @JsonKey(name: 'data')
  List<Alias> aliases;

  factory AliasModel.fromJson(Map<String, dynamic> json) =>
      _$AliasModelFromJson(json);

  Map<String, dynamic> toJson() => _$AliasModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Alias {
  Alias({
    required this.id,
    required this.userId,
    this.aliasableId,
    this.aliasableType,
    required this.localPart,
    this.extension,
    required this.domain,
    required this.email,
    required this.active,
    this.description,
    required this.emailsForwarded,
    required this.emailsBlocked,
    required this.emailsReplied,
    required this.emailsSent,
    required this.recipients,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  String id;
  @JsonKey(name: 'user_id')
  String userId;
  @JsonKey(name: 'aliasable_id')
  String? aliasableId;
  @JsonKey(name: 'aliasable_type')
  String? aliasableType;
  @JsonKey(name: 'local_part')
  String localPart;
  String? extension;
  String domain;
  String email;
  bool active;
  String? description;
  @JsonKey(name: 'emails_forwarded')
  int emailsForwarded;
  @JsonKey(name: 'emails_blocked')
  int emailsBlocked;
  @JsonKey(name: 'emails_replied')
  int emailsReplied;
  @JsonKey(name: 'emails_sent')
  int emailsSent;
  List<Recipient>? recipients;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  DateTime? deletedAt;

  factory Alias.fromJson(Map<String, dynamic> json) => _$AliasFromJson(json);

  Map<String, dynamic> toJson() => _$AliasToJson(this);
}
