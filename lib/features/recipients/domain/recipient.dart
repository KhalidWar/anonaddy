import 'package:anonaddy/features/aliases/domain/alias.dart';
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
    required this.canReplySend,
    required this.shouldEncrypt,
    required this.inlineEncryption,
    required this.protectedHeaders,
    required this.createdAt,
    required this.aliasesCount,
    this.emailVerifiedAt,
    this.updatedAt,
    this.fingerprint,
    this.aliases,
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
  final String? fingerprint;

  @JsonKey(name: 'email_verified_at')
  @HiveField(5)
  final DateTime? emailVerifiedAt;

  @HiveField(6)
  final List<Alias>? aliases;

  @JsonKey(name: 'created_at')
  @HiveField(7)
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  @HiveField(8)
  final DateTime? updatedAt;

  @JsonKey(name: 'can_reply_send')
  @HiveField(9)
  final bool canReplySend;

  @JsonKey(name: 'inline_encryption')
  @HiveField(10)
  final bool inlineEncryption;

  @JsonKey(name: 'protected_headers')
  @HiveField(11)
  final bool protectedHeaders;

  @JsonKey(name: 'aliases_count')
  @HiveField(12)
  final int? aliasesCount;

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);

  Recipient copyWith({
    String? id,
    String? userId,
    String? email,
    bool? shouldEncrypt,
    String? fingerprint,
    DateTime? emailVerifiedAt,
    List<Alias>? aliases,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? canReplySend,
    bool? inlineEncryption,
    bool? protectedHeaders,
    int? aliasesCount,
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
      canReplySend: canReplySend ?? this.canReplySend,
      inlineEncryption: inlineEncryption ?? this.inlineEncryption,
      protectedHeaders: protectedHeaders ?? this.protectedHeaders,
      aliasesCount: aliasesCount ?? this.aliasesCount,
    );
  }

  @override
  String toString() {
    return 'Recipient{id: $id, userId: $userId, email: $email, shouldEncrypt: $shouldEncrypt, fingerprint: $fingerprint, emailVerifiedAt: $emailVerifiedAt, aliases: $aliases, createdAt: $createdAt, updatedAt: $updatedAt, canReplySend: $canReplySend, inlineEncryption: $inlineEncryption, protectedHeaders: $protectedHeaders, aliasesCount: $aliasesCount}';
  }
}

extension RecipientExtension on Recipient {
  bool get isVerified => emailVerifiedAt != null;
  bool get isEncrypted => fingerprint != null && shouldEncrypt;
}
