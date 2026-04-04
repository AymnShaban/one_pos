part of '../new_invoice_imports.dart';

class QtyExpireDateModel extends Equatable {
  final int productId;
  final double stockQuantity;
  final String expireDate;
  final String notes;
  final int storeId;

  const QtyExpireDateModel({
    required this.productId,
    required this.stockQuantity,
    required this.expireDate,
    required this.notes,
    required this.storeId,
  });

  factory QtyExpireDateModel.fromJson(Map<String, dynamic> json) {
    return QtyExpireDateModel(
      productId:     json['ProductID']     ?? 0,
      stockQuantity: (json['StockQuantity'] ?? 0).toDouble(),
      expireDate:    json['ExpireDate']    ?? '',
      notes:         json['Notes']         ?? '',
      storeId:       json['StoreID']       ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'ProductID':     productId,
    'StockQuantity': stockQuantity,
    'ExpireDate':    expireDate,
    'Notes':         notes,
    'StoreID':       storeId,
  };

  String get formattedExpireDate {
    if (expireDate.isEmpty) return '';
    try {
      final d = DateTime.parse(expireDate);
      return '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
    } catch (_) {
      return expireDate;
    }
  }

  @override
  List<Object?> get props => [productId, expireDate, notes, storeId];
}