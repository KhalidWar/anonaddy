// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipientAdapter extends TypeAdapter<Recipient> {
  @override
  final int typeId = 1;

  @override
  Recipient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipient(
      id: fields[0] as String,
      userId: fields[1] as String,
      email: fields[2] as String,
      canReplySend: fields[9] as bool,
      shouldEncrypt: fields[3] as bool,
      inlineEncryption: fields[10] as bool,
      protectedHeaders: fields[11] as bool,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      aliasesCount: fields[12] as int?,
      emailVerifiedAt: fields[5] as DateTime?,
      fingerprint: fields[4] as String?,
      aliases: (fields[6] as List?)?.cast<Alias>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipient obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.shouldEncrypt)
      ..writeByte(4)
      ..write(obj.fingerprint)
      ..writeByte(5)
      ..write(obj.emailVerifiedAt)
      ..writeByte(6)
      ..write(obj.aliases)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.canReplySend)
      ..writeByte(10)
      ..write(obj.inlineEncryption)
      ..writeByte(11)
      ..write(obj.protectedHeaders)
      ..writeByte(12)
      ..write(obj.aliasesCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipient _$RecipientFromJson(Map<String, dynamic> json) => Recipient(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      email: json['email'] as String,
      canReplySend: json['can_reply_send'] as bool,
      shouldEncrypt: json['should_encrypt'] as bool,
      inlineEncryption: json['inline_encryption'] as bool,
      protectedHeaders: json['protected_headers'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      aliasesCount: json['aliases_count'] as int?,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      fingerprint: json['fingerprint'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
          ?.map((e) => Alias.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecipientToJson(Recipient instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'email': instance.email,
      'should_encrypt': instance.shouldEncrypt,
      'fingerprint': instance.fingerprint,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'aliases': instance.aliases?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'can_reply_send': instance.canReplySend,
      'inline_encryption': instance.inlineEncryption,
      'protected_headers': instance.protectedHeaders,
      'aliases_count': instance.aliasesCount,
    };
