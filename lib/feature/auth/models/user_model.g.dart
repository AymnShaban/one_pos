// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userId: fields[0] as int,
      userName: fields[1] as String,
      fullUserName: fields[2] as String,
      employeeId: fields[3] as int?,
      token: fields[4] as String,
      accessPermission: fields[5] as String,
      accBR: fields[6] as String,
      showPrice: fields[7] as bool,
      ciAccP: fields[8] as String?,
      fullAccess: fields[9] as bool,
      userBranches: fields[10] as String,
      userBranchesList: (fields[11] as List).cast<String>(),
      userStores: fields[12] as String,
      userStoresList: (fields[13] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.fullUserName)
      ..writeByte(3)
      ..write(obj.employeeId)
      ..writeByte(4)
      ..write(obj.token)
      ..writeByte(5)
      ..write(obj.accessPermission)
      ..writeByte(6)
      ..write(obj.accBR)
      ..writeByte(7)
      ..write(obj.showPrice)
      ..writeByte(8)
      ..write(obj.ciAccP)
      ..writeByte(9)
      ..write(obj.fullAccess)
      ..writeByte(10)
      ..write(obj.userBranches)
      ..writeByte(11)
      ..write(obj.userBranchesList)
      ..writeByte(12)
      ..write(obj.userStores)
      ..writeByte(13)
      ..write(obj.userStoresList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
