part of '../favorite_imports.dart';

class FavoriteModel {
  final int? id;
  final int? productID;
  final String? customerPhone;
  final int? customerID;
  final String? productCode;
  final String? productName;
  final String? productEnName;
  final String? specifications;
  final double? discountPercent;
  final String? productImage;
  final int? categoryId;
  final double? stockQuantity;
  final double? price;
  final double? priceAfterDiscount;
  final double? customerQuantity;
  final double? totalQuantity;
  final String? barCode;
  final double? requiredQTY;
  final double? giftQTY;
  final double? yGiftQty;

  const FavoriteModel({
    this.id,
    this.productID,
    this.customerPhone,
    this.customerID,
    this.productCode,
    this.productName,
    this.productEnName,
    this.specifications,
    this.discountPercent,
    this.productImage,
    this.categoryId,
    this.stockQuantity,
    this.price,
    this.priceAfterDiscount,
    this.customerQuantity,
    this.totalQuantity,
    this.barCode,
    this.requiredQTY,
    this.giftQTY,
    this.yGiftQty,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: _parseToInt(json['ID']),
      productID: _parseToInt(json['ProductID']),
      customerPhone: json['CustomerPhone']?.toString(),
      customerID: _parseToInt(json['CustomerID']),
      productCode: json['ProductCode']?.toString(),
      productName: json['ProductName']?.toString(),
      productEnName: json['ProductEnName']?.toString(),
      specifications: json['Specifications']?.toString(),
      discountPercent: _parseToDouble(json['DiscountPercent']),
      productImage: json['ProductImage']?.toString(),
      categoryId: _parseToInt(json['CategoryId']),
      stockQuantity: _parseToDouble(json['StockQuantity']),
      price: _parseToDouble(json['Price']),
      priceAfterDiscount: _parseToDouble(json['PriceAfterDiscount']),
      customerQuantity: _parseToDouble(json['CustomerQuantity']),
      totalQuantity: _parseToDouble(json['TotalQuantity']),
      barCode: json['BarCode']?.toString(),
      requiredQTY: _parseToDouble(json['RequiredQTY']),
      giftQTY: _parseToDouble(json['GiftQTY']),
      yGiftQty: _parseToDouble(json['Y_Gift_Qty']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'ProductID': productID,
      'CustomerPhone': customerPhone,
      'CustomerID': customerID,
      'ProductCode': productCode,
      'ProductName': productName,
      'ProductEnName': productEnName,
      'Specifications': specifications,
      'DiscountPercent': discountPercent,
      'ProductImage': productImage,
      'CategoryId': categoryId,
      'StockQuantity': stockQuantity,
      'Price': price,
      'PriceAfterDiscount': priceAfterDiscount,
      'CustomerQuantity': customerQuantity,
      'TotalQuantity': totalQuantity,
      'BarCode': barCode,
      'RequiredQTY': requiredQTY,
      'GiftQTY': giftQTY,
      'Y_Gift_Qty': yGiftQty,
    };
  }

  // Helper methods for safe parsing
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  static double? _parseToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }


  bool get isValidProduct => productID != null && productName != null;

  bool get hasDiscount => discountPercent != null && discountPercent! > 0;

  bool get isInStock => stockQuantity != null && stockQuantity! > 0;

  double get finalPrice => priceAfterDiscount ?? price ?? 0.0;

  FavoriteModel copyWith({
    int? id,
    int? productID,
    String? customerPhone,
    int? customerID,
    String? productCode,
    String? productName,
    String? productEnName,
    String? specifications,
    double? discountPercent,
    String? productImage,
    int? categoryId,
    double? stockQuantity,
    double? price,
    double? priceAfterDiscount,
    double? customerQuantity,
    double? totalQuantity,
    String? barCode,
    double? requiredQTY,
    double? giftQTY,
    double? yGiftQty,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      productID: productID ?? this.productID,
      customerPhone: customerPhone ?? this.customerPhone,
      customerID: customerID ?? this.customerID,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      productEnName: productEnName ?? this.productEnName,
      specifications: specifications ?? this.specifications,
      discountPercent: discountPercent ?? this.discountPercent,
      productImage: productImage ?? this.productImage,
      categoryId: categoryId ?? this.categoryId,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      price: price ?? this.price,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      customerQuantity: customerQuantity ?? this.customerQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      barCode: barCode ?? this.barCode,
      requiredQTY: requiredQTY ?? this.requiredQTY,
      giftQTY: giftQTY ?? this.giftQTY,
      yGiftQty: yGiftQty ?? this.yGiftQty,
    );
  }

  // Equality and hashCode for proper comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteModel &&
        other.id == id &&
        other.productID == productID &&
        other.customerPhone == customerPhone &&
        other.customerID == customerID &&
        other.productCode == productCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productID,
      customerPhone,
      customerID,
      productCode,
    );
  }

  @override
  String toString() {
    return 'FavoriteModel(id: $id, productName: $productName, price: $price, customerID: $customerID)';
  }
}