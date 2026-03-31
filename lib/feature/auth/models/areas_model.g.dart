// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'areas_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AreasModelAdapter extends TypeAdapter<AreasModel> {
  @override
  final int typeId = 4;

  @override
  AreasModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AreasModel(
      districtID: fields[0] as int,
      governorateID: fields[1] as int,
      deliveryValue: fields[2] as num,
      districtName: fields[3] as String,
      districtEName: fields[4] as String,
      billValue: fields[5] as num,
      paymentMethod: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AreasModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.districtID)
      ..writeByte(1)
      ..write(obj.governorateID)
      ..writeByte(2)
      ..write(obj.deliveryValue)
      ..writeByte(3)
      ..write(obj.districtName)
      ..writeByte(4)
      ..write(obj.districtEName)
      ..writeByte(5)
      ..write(obj.billValue)
      ..writeByte(6)
      ..write(obj.paymentMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreasModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
