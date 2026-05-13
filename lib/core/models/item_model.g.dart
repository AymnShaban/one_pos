// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 3;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      productCode: fields[0] as String,
      barCode: fields[1] as String,
      colorArName: fields[2] as String?,
      colorEnName: fields[3] as String?,
      sizeName: fields[4] as String?,
      sizeEName: fields[5] as String?,
      productId: fields[20] as int,
      productArName: fields[6] as String,
      productEnName: fields[7] as String,
      categoryArName: fields[8] as String,
      categoryEnName: fields[12] as String,
      productImage: fields[13] as String?,
      isFavorite: fields[14] as bool,
      price: fields[15] as double,
      priceAfterDiscount: fields[18] as double,
      registrationDate: fields[19] as String,
      stockQuantity: fields[16] as num,
      description1: fields[21] as String?,
      description2: fields[22] as String?,
      description3: fields[23] as String?,
      description4: fields[24] as String?,
      description5: fields[25] as String?,
      description6: fields[26] as String?,
      description7: fields[27] as String?,
      description8: fields[28] as String?,
      description9: fields[29] as String?,
      description10: fields[30] as String?,
      categoryId: fields[17] as String?,
      defaultUnitEnName: fields[32] as String?,
      defaultUnitArName: fields[31] as String?,
      unitValue: fields[33] as num?,
      unitEnName: fields[35] as String?,
      unitArName: fields[34] as String?,
      brandID: fields[36] as String?,
      customerQuantity: fields[37] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.productCode)
      ..writeByte(1)
      ..write(obj.barCode)
      ..writeByte(2)
      ..write(obj.colorArName)
      ..writeByte(3)
      ..write(obj.colorEnName)
      ..writeByte(4)
      ..write(obj.sizeName)
      ..writeByte(5)
      ..write(obj.sizeEName)
      ..writeByte(6)
      ..write(obj.productArName)
      ..writeByte(7)
      ..write(obj.productEnName)
      ..writeByte(8)
      ..write(obj.categoryArName)
      ..writeByte(12)
      ..write(obj.categoryEnName)
      ..writeByte(13)
      ..write(obj.productImage)
      ..writeByte(14)
      ..write(obj.isFavorite)
      ..writeByte(15)
      ..write(obj.price)
      ..writeByte(16)
      ..write(obj.stockQuantity)
      ..writeByte(17)
      ..write(obj.categoryId)
      ..writeByte(18)
      ..write(obj.priceAfterDiscount)
      ..writeByte(19)
      ..write(obj.registrationDate)
      ..writeByte(20)
      ..write(obj.productId)
      ..writeByte(21)
      ..write(obj.description1)
      ..writeByte(22)
      ..write(obj.description2)
      ..writeByte(23)
      ..write(obj.description3)
      ..writeByte(24)
      ..write(obj.description4)
      ..writeByte(25)
      ..write(obj.description5)
      ..writeByte(26)
      ..write(obj.description6)
      ..writeByte(27)
      ..write(obj.description7)
      ..writeByte(28)
      ..write(obj.description8)
      ..writeByte(29)
      ..write(obj.description9)
      ..writeByte(30)
      ..write(obj.description10)
      ..writeByte(31)
      ..write(obj.defaultUnitArName)
      ..writeByte(32)
      ..write(obj.defaultUnitEnName)
      ..writeByte(33)
      ..write(obj.unitValue)
      ..writeByte(34)
      ..write(obj.unitArName)
      ..writeByte(35)
      ..write(obj.unitEnName)
      ..writeByte(36)
      ..write(obj.brandID)
      ..writeByte(37)
      ..write(obj.customerQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BadgeTypeAdapter extends TypeAdapter<BadgeType> {
  @override
  final int typeId = 2;

  @override
  BadgeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BadgeType.offer;
      case 1:
        return BadgeType.outOfStock;
      case 2:
        return BadgeType.none;
      default:
        return BadgeType.offer;
    }
  }

  @override
  void write(BinaryWriter writer, BadgeType obj) {
    switch (obj) {
      case BadgeType.offer:
        writer.writeByte(0);
        break;
      case BadgeType.outOfStock:
        writer.writeByte(1);
        break;
      case BadgeType.none:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
