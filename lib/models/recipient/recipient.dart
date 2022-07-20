import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/shared_components/constants/hive_type_id.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipient.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypeId.recipient)
class Recipient extends HiveObject {
  Recipient({
    this.id = '',
    this.userId = '',
    this.email = '',
    this.shouldEncrypt = false,
    this.fingerprint = '',
    this.emailVerifiedAt = '',
    this.aliases = const <Alias>[],
    this.createdAt = '',
    this.updatedAt = '',
  });

  @HiveField(0)
  final String id;

  @JsonKey(name: 'user_id')
  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String email;

  @JsonKey(name: 'should_encrypt')
  @HiveField(3)
  final bool shouldEncrypt;

  @HiveField(4)
  final String fingerprint;

  @JsonKey(name: 'email_verified_at')
  @HiveField(5)
  final String emailVerifiedAt;

  @HiveField(6)
  final List<Alias> aliases;

  @JsonKey(name: 'created_at')
  @HiveField(7)
  final String createdAt;

  @JsonKey(name: 'updated_at')
  @HiveField(8)
  final String updatedAt;

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);

  Recipient copyWith({
    String? id,
    String? userId,
    String? email,
    bool? shouldEncrypt,
    String? fingerprint,
    String? emailVerifiedAt,
    List<Alias>? aliases,
    String? createdAt,
    String? updatedAt,
  }) {
    return Recipient(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      shouldEncrypt: shouldEncrypt ?? this.shouldEncrypt,
      fingerprint: fingerprint ?? this.fingerprint,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      aliases: aliases ?? this.aliases,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Recipient{id: $id, userId: $userId, email: $email, shouldEncrypt: $shouldEncrypt, fingerprint: $fingerprint, emailVerifiedAt: $emailVerifiedAt, aliases: $aliases, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
