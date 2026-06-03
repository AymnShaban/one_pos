// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceProductAdapter extends TypeAdapter<InvoiceProduct> {
  @override
  final int typeId = 5;

  @override
  InvoiceProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceProduct(
      id: fields[0] as String,
      barcode: fields[1] as String,
      quantity: fields[2] as double,
      productId: fields[3] as int,
      productArName: fields[4] as String,
      productEnName: fields[5] as String,
      stockQuantity: fields[6] as num,
      realQuantity: fields[7] as num,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceProduct obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.barcode)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.productId)
      ..writeByte(4)
      ..write(obj.productArName)
      ..writeByte(5)
      ..write(obj.productEnName)
      ..writeByte(6)
      ..write(obj.stockQuantity)
      ..writeByte(7)
      ..write(obj.realQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
