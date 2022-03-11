// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alias.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AliasAdapter extends TypeAdapter<Alias> {
  @override
  final int typeId = 0;

  @override
  Alias read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Alias(
      id: fields[0] as String,
      userId: fields[1] as String,
      aliasableId: fields[2] as String?,
      aliasableType: fields[3] as String?,
      localPart: fields[4] as String,
      extension: fields[5] as String?,
      domain: fields[6] as String,
      email: fields[7] as String,
      active: fields[8] as bool,
      description: fields[9] as String?,
      emailsForwarded: fields[10] as int,
      emailsBlocked: fields[11] as int,
      emailsReplied: fields[12] as int,
      emailsSent: fields[13] as int,
      recipients: (fields[14] as List?)?.cast<Recipient>(),
      createdAt: fields[15] as DateTime,
      updatedAt: fields[16] as DateTime,
      deletedAt: fields[17] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Alias obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.aliasableId)
      ..writeByte(3)
      ..write(obj.aliasableType)
      ..writeByte(4)
      ..write(obj.localPart)
      ..writeByte(5)
      ..write(obj.extension)
      ..writeByte(6)
      ..write(obj.domain)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.active)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.emailsForwarded)
      ..writeByte(11)
      ..write(obj.emailsBlocked)
      ..writeByte(12)
      ..write(obj.emailsReplied)
      ..writeByte(13)
      ..write(obj.emailsSent)
      ..writeByte(14)
      ..write(obj.recipients)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt)
      ..writeByte(17)
      ..write(obj.deletedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AliasAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alias _$AliasFromJson(Map<String, dynamic> json) => Alias(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      aliasableId: json['aliasable_id'] as String?,
      aliasableType: json['aliasable_type'] as String?,
      localPart: json['local_part'] as String,
      extension: json['extension'] as String?,
      domain: json['domain'] as String,
      email: json['email'] as String,
      active: json['active'] as bool,
      description: json['description'] as String?,
      emailsForwarded: json['emails_forwarded'] as int,
      emailsBlocked: json['emails_blocked'] as int,
      emailsReplied: json['emails_replied'] as int,
      emailsSent: json['emails_sent'] as int,
      recipients: (json['recipients'] as List<dynamic>?)
          ?.map((e) => Recipient.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$AliasToJson(Alias instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'aliasable_id': instance.aliasableId,
      'aliasable_type': instance.aliasableType,
      'local_part': instance.localPart,
      'extension': instance.extension,
      'domain': instance.domain,
      'email': instance.email,
      'active': instance.active,
      'description': instance.description,
      'emails_forwarded': instance.emailsForwarded,
      'emails_blocked': instance.emailsBlocked,
      'emails_replied': instance.emailsReplied,
      'emails_sent': instance.emailsSent,
      'recipients': instance.recipients?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
