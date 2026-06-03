// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barren_invoice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarrenInvoiceModelAdapter extends TypeAdapter<BarrenInvoiceModel> {
  @override
  final int typeId = 1;

  @override
  BarrenInvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarrenInvoiceModel(
      savedAt: fields[0] as DateTime,
      products: (fields[1] as List).cast<InvoiceProduct>(),
    );
  }

  @override
  void write(BinaryWriter writer, BarrenInvoiceModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.savedAt)
      ..writeByte(1)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarrenInvoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
