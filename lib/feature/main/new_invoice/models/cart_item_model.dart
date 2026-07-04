part of '../new_invoice_imports.dart';

class CartItemModel extends Equatable {
  final int productId;
  final String productArName;
  final String productEnName;
  final String defaultUnitName;
  final double price;
  final num stockQuantity;
  final num quantity;
  final num discountPercent;
  final String notes;
  final int rowNumber;
  final String rowState; // N = new, U = updated, D = deleted
  final List<QtyExpireDateModel>? qtyExpireDates;
  final QtyExpireDateModel? selectedExpireDate;

  const CartItemModel({
    required this.productId,
    required this.productArName,
    required this.productEnName,
    required this.defaultUnitName,
    required this.price,
    required this.stockQuantity,
    required this.quantity,
    this.discountPercent = 0,
    this.notes = '',
    this.rowNumber = 1,
    this.rowState = 'N',
    this.qtyExpireDates,
    this.selectedExpireDate,
  });

  CartItemModel copyWith({
    int?    productId,
    String? productArName,
    String? productEnName,
    String? defaultUnitName,
    double? price,
    num?    stockQuantity,
    num?    quantity,
    num?    discountPercent,
    String? notes,
    int?    rowNumber,
    String? rowState,
    List<QtyExpireDateModel>? qtyExpireDates,
    QtyExpireDateModel?       selectedExpireDate,
  }) {
    return CartItemModel(
      productId:         productId         ?? this.productId,
      productArName:     productArName     ?? this.productArName,
      productEnName:     productEnName     ?? this.productEnName,
      defaultUnitName:   defaultUnitName   ?? this.defaultUnitName,
      price:             price             ?? this.price,
      stockQuantity:     stockQuantity     ?? this.stockQuantity,
      quantity:          quantity          ?? this.quantity,
      discountPercent:   discountPercent   ?? this.discountPercent,
      notes:             notes             ?? this.notes,
      rowNumber:         rowNumber         ?? this.rowNumber,
      rowState:          rowState          ?? this.rowState,
      qtyExpireDates:    qtyExpireDates    ?? this.qtyExpireDates,
      selectedExpireDate: selectedExpireDate ?? this.selectedExpireDate,
    );
  }

  Map<String, dynamic> toInvoiceJson() {
    final map = <String, dynamic>{
      'productID':       productId,
      'rowNumber':       rowNumber,
      'quantity':        quantity,
      'price':           price,
      'notes':           notes,
      'rowSate':         rowState,
      'discountPercent': discountPercent,
    };
    if (selectedExpireDate != null) {
      map['expireDate'] = selectedExpireDate!.expireDate;
      map['BatchNo']    = selectedExpireDate!.notes;
      map['storeID']    = selectedExpireDate!.storeId;
    }
    return map;
  }

  double get lineTotal =>
      (quantity * price * (1 - discountPercent / 100)).toDouble();

  @override
  List<Object?> get props => [
    productId, quantity, price, rowNumber, rowState, discountPercent, notes,
  ];
}