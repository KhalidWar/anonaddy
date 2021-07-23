// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipientDataModelAdapter extends TypeAdapter<RecipientDataModel> {
  @override
  final int typeId = 1;

  @override
  RecipientDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipientDataModel(
      id: fields[0] as String,
      userId: fields[1] as String?,
      email: fields[2] as String?,
      shouldEncrypt: fields[3] as bool?,
      fingerprint: fields[4] as String?,
      emailVerifiedAt: fields[5] as DateTime?,
      aliases: (fields[6] as List?)?.cast<AliasDataModel>(),
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RecipientDataModel obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipientDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
