import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipient.g.dart';

@JsonSerializable(explicitToJson: true)
class Recipient {
  Recipient({
    required this.id,
    required this.userId,
    required this.email,
    required this.canReplySend,
    required this.shouldEncrypt,
    required this.inlineEncryption,
    required this.protectedHeaders,
    required this.createdAt,
    required this.updatedAt,
    required this.aliasesCount,
    this.emailVerifiedAt,
    this.fingerprint,
    this.aliases,
  });

  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  final String email;

  @JsonKey(name: 'should_encrypt')
  final bool shouldEncrypt;

  final String? fingerprint;

  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;

  final List<Alias>? aliases;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'can_reply_send')
  final bool canReplySend;

  @JsonKey(name: 'inline_encryption')
  final bool inlineEncryption;

  @JsonKey(name: 'protected_headers')
  final bool protectedHeaders;

  @JsonKey(name: 'aliases_count')
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
