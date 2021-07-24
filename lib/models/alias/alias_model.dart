import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:hive/hive.dart';
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
@HiveType(typeId: 0)
class Alias extends HiveObject {
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

  @HiveField(0)
  String id;

  @JsonKey(name: 'user_id')
  @HiveField(1)
  String userId;

  @JsonKey(name: 'aliasable_id')
  @HiveField(2)
  String? aliasableId;

  @JsonKey(name: 'aliasable_type')
  @HiveField(3)
  String? aliasableType;

  @JsonKey(name: 'local_part')
  @HiveField(4)
  String localPart;

  @HiveField(5)
  String? extension;

  @HiveField(6)
  String domain;

  @HiveField(7)
  String email;

  @HiveField(8)
  bool active;

  @HiveField(9)
  String? description;

  @JsonKey(name: 'emails_forwarded')
  @HiveField(10)
  int emailsForwarded;

  @JsonKey(name: 'emails_blocked')
  @HiveField(11)
  int emailsBlocked;

  @JsonKey(name: 'emails_replied')
  @HiveField(12)
  int emailsReplied;

  @JsonKey(name: 'emails_sent')
  @HiveField(13)
  int emailsSent;

  @HiveField(14)
  List<Recipient>? recipients;

  @JsonKey(name: 'created_at')
  @HiveField(15)
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  @HiveField(16)
  DateTime updatedAt;

  @JsonKey(name: 'deleted_at')
  @HiveField(17)
  DateTime? deletedAt;

  factory Alias.fromJson(Map<String, dynamic> json) => _$AliasFromJson(json);

  Map<String, dynamic> toJson() => _$AliasToJson(this);
}
