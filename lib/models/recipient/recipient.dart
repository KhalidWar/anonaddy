import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/shared_components/constants/hive_type_id.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipient.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypeId.recipient)
class Recipient extends HiveObject {
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

  @HiveField(0)
  String id;

  @JsonKey(name: 'user_id')
  @HiveField(1)
  String userId;

  @HiveField(2)
  String email;

  @JsonKey(name: 'should_encrypt')
  @HiveField(3)
  bool shouldEncrypt;

  @HiveField(4)
  String? fingerprint;

  @JsonKey(name: 'email_verified_at')
  @HiveField(5)
  DateTime? emailVerifiedAt;

  @HiveField(6)
  List<Alias>? aliases;

  @JsonKey(name: 'created_at')
  @HiveField(7)
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  @HiveField(8)
  DateTime updatedAt;

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);

  @override
  String toString() {
    return 'Recipient{id: $id, userId: $userId, email: $email, shouldEncrypt: $shouldEncrypt, fingerprint: $fingerprint, emailVerifiedAt: $emailVerifiedAt, aliases: $aliases, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
