import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:hive/hive.dart';

part 'recipient_data_model.g.dart';

@HiveType(typeId: 1)
class RecipientDataModel extends HiveObject {
  RecipientDataModel({
    this.id,
    this.userId,
    this.email,
    this.shouldEncrypt,
    this.fingerprint,
    this.emailVerifiedAt,
    this.aliases,
    this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String email;
  @HiveField(3)
  bool shouldEncrypt;
  @HiveField(4)
  String fingerprint;
  @HiveField(5)
  DateTime emailVerifiedAt;
  @HiveField(6)
  List<AliasDataModel> aliases;
  @HiveField(7)
  DateTime createdAt;
  @HiveField(8)
  DateTime updatedAt;

  factory RecipientDataModel.fromJson(Map<String, dynamic> json) {
    List list = json['aliases'];
    List<AliasDataModel> aliasesList =
        list.map((i) => AliasDataModel.fromJson(i)).toList();

    return RecipientDataModel(
      id: json["id"],
      userId: json["user_id"],
      email: json["email"],
      shouldEncrypt: json["should_encrypt"],
      fingerprint: json["fingerprint"],
      emailVerifiedAt: json["email_verified_at"] == null
          ? null
          : DateTime.parse(json["email_verified_at"]),
      aliases: aliasesList,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  factory RecipientDataModel.fromJsonRecipientNoAliases(
      Map<String, dynamic> json) {
    // DefaultRecipient coming from AdditionalUsername do NOT have "aliases"
    return RecipientDataModel(
      id: json["id"],
      userId: json["user_id"],
      email: json["email"],
      shouldEncrypt: json["should_encrypt"],
      fingerprint: json["fingerprint"],
      emailVerifiedAt: json["email_verified_at"] == null
          ? null
          : DateTime.parse(json["email_verified_at"]),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  factory RecipientDataModel.fromJsonData(Map<String, dynamic> json) {
    return RecipientDataModel(
      shouldEncrypt: json["data"]["should_encrypt"],
      fingerprint: json["data"]["fingerprint"],
    );
  }
}
