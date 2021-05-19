// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alias_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AliasDataModelAdapter extends TypeAdapter<AliasDataModel> {
  @override
  final int typeId = 0;

  @override
  AliasDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AliasDataModel(
      aliasID: fields[0] as String,
      userId: fields[1] as String,
      aliasableId: fields[2] as dynamic,
      aliasableType: fields[3] as dynamic,
      localPart: fields[4] as String,
      extension: fields[5] as dynamic,
      domain: fields[6] as String,
      email: fields[7] as String,
      isAliasActive: fields[8] as bool,
      emailDescription: fields[9] as String,
      emailsForwarded: fields[10] as int,
      emailsBlocked: fields[11] as int,
      emailsReplied: fields[12] as int,
      emailsSent: fields[13] as int,
      recipients: (fields[14] as List)?.cast<RecipientDataModel>(),
      createdAt: fields[15] as DateTime,
      updatedAt: fields[16] as DateTime,
      deletedAt: fields[17] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AliasDataModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.aliasID)
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
      ..write(obj.isAliasActive)
      ..writeByte(9)
      ..write(obj.emailDescription)
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
      other is AliasDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
