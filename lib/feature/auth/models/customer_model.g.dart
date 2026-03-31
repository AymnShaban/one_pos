// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerModelAdapter extends TypeAdapter<CustomerModel> {
  @override
  final int typeId = 0;

  @override
  CustomerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerModel(
      customerId: fields[0] as int,
      arabicName: fields[1] as String?,
      englishName: fields[2] as String?,
      customerPhone: fields[3] as String?,
      lastName: fields[4] as String?,
      password: fields[5] as String,
      email: fields[6] as String,
      regionId: fields[7] as int,
      regionName: fields[8] as String?,
      placeId: fields[9] as int,
      districtName: fields[10] as String?,
      streetName: fields[11] as String?,
      gada: fields[12] as String?,
      houseNo: fields[13] as String?,
      block: fields[14] as String?,
      floor: fields[15] as String?,
      apartment: fields[16] as String?,
      addressNotes: fields[17] as String?,
      customerAddress: fields[18] as String?,
      billValue: fields[19] as double?,
      paymentMethod: fields[20] as String?,
      deliveryValue: fields[21] as double?,
      districtName2: fields[22] as String?,
      districtEName2: fields[23] as String?,
      token: fields[24] as String?,
      mapCustomerAddress: fields[25] as String?,
      mapPlaceId: fields[26] as String?,
      addressId: fields[27] as String,
      customerLastName: fields[28] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerModel obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.customerId)
      ..writeByte(1)
      ..write(obj.arabicName)
      ..writeByte(2)
      ..write(obj.englishName)
      ..writeByte(3)
      ..write(obj.customerPhone)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.regionId)
      ..writeByte(8)
      ..write(obj.regionName)
      ..writeByte(9)
      ..write(obj.placeId)
      ..writeByte(10)
      ..write(obj.districtName)
      ..writeByte(11)
      ..write(obj.streetName)
      ..writeByte(12)
      ..write(obj.gada)
      ..writeByte(13)
      ..write(obj.houseNo)
      ..writeByte(14)
      ..write(obj.block)
      ..writeByte(15)
      ..write(obj.floor)
      ..writeByte(16)
      ..write(obj.apartment)
      ..writeByte(17)
      ..write(obj.addressNotes)
      ..writeByte(18)
      ..write(obj.customerAddress)
      ..writeByte(19)
      ..write(obj.billValue)
      ..writeByte(20)
      ..write(obj.paymentMethod)
      ..writeByte(21)
      ..write(obj.deliveryValue)
      ..writeByte(22)
      ..write(obj.districtName2)
      ..writeByte(23)
      ..write(obj.districtEName2)
      ..writeByte(24)
      ..write(obj.token)
      ..writeByte(25)
      ..write(obj.mapCustomerAddress)
      ..writeByte(26)
      ..write(obj.mapPlaceId)
      ..writeByte(27)
      ..write(obj.addressId)
      ..writeByte(28)
      ..write(obj.customerLastName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
