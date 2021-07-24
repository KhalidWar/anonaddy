import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipient_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RecipientModel {
  RecipientModel({required this.recipients});

  @JsonKey(name: 'data')
  List<Recipient> recipients;

  factory RecipientModel.fromJson(Map<String, dynamic> json) =>
      _$RecipientModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Recipient {
  Recipient({
    required this.id,
    required this.userId,
    required this.email,
    required this.shouldEncrypt,
    this.fingerprint,
    this.emailVerifiedAt,
    required this.aliases,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  @JsonKey(name: 'user_id')
  String userId;
  String email;
  @JsonKey(name: 'should_encrypt')
  bool shouldEncrypt;
  String? fingerprint;
  @JsonKey(name: 'email_verified_at')
  DateTime? emailVerifiedAt;
  List<Alias>? aliases;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}
