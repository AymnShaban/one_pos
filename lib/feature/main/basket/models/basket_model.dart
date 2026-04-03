part of '../basket_imports.dart';

class BasketItemModel extends Equatable {
  final int customerID;
  final String customerName;
  final String customerEName;
  final int productID;
  final String productCode;
  final String productName;
  final String productEnName;
  final int salesQuantity;
  final String barCode;
  final String customerPhone;
  final String specifications;
  final int discountPercent;
  final String productImage;
  final double stockQuantity;
  final double price;
  final double customerQuantity;
  final double totalQuantity;
  final int requiredQTY;
  final int giftQTY;
  final int yGiftQty;
  final int categoryId;
  final String? description1;
  final String? description2;

  final double priceBeforeDiscount;
  final double priceAfterDiscount;

  const BasketItemModel({
    required this.customerID,
    required this.customerName,
    required this.customerEName,
    required this.productID,
    required this.productCode,
    required this.productName,
    required this.productEnName,
    required this.salesQuantity,
    required this.barCode,
    required this.customerPhone,
    required this.specifications,
    required this.discountPercent,
    required this.productImage,
    required this.stockQuantity,
    required this.price,
    required this.customerQuantity,
    required this.totalQuantity,
    required this.requiredQTY,
    required this.giftQTY,
    required this.yGiftQty,
    required this.categoryId,
    required this.priceBeforeDiscount,
    required this.priceAfterDiscount,
    this.description1,
    this.description2,
  });

  factory BasketItemModel.fromJson(Map<String, dynamic> json) {
    return BasketItemModel(
      customerID: json['CustomerID'] ?? 0,
      customerName: json['CustomerName'] ?? '',
      customerEName: json['CustomerEName'] ?? '',
      productID: json['ProductID'] ?? 0,
      productCode: json['ProductCode'] ?? '',
      productName: json['ProductName'] ?? '',
      productEnName: json['ProductEnName'] ?? '',
      salesQuantity: json['SalesQuantity'] ?? 0,
      barCode: json['BarCode'] ?? '',
      customerPhone: json['CustomerPhone'] ?? '',
      specifications: json['Specifications'] ?? '',
      discountPercent: json['DiscountPercent'] ?? 0,
      productImage: json['ProductImage'] ?? '',
      stockQuantity: json['StockQuantity'] ?? 0.0,
      price: json['Price'] ?? 0.0,
      customerQuantity: json['CustomerQuantity'] ?? 0.0,
      totalQuantity: json['TotalQuantity'] ?? 0.0,
      requiredQTY: json['RequiredQTY'] ?? 0,
      giftQTY: json['GiftQTY'] ?? 0,
      yGiftQty: json['Y_Gift_Qty'] ?? 0,
      categoryId: json['CategoryId'] ?? 0,
      description1: json['Description1'] ?? '',
      description2: json['Description2'] ?? '',
      priceBeforeDiscount: json['PriceBeforeDiscount'] ?? 0.0,
      priceAfterDiscount: json['PriceAfterDiscount'] ?? 0.0,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'CustomerID': customerID,
      'CustomerName': customerName,
      'CustomerEName': customerEName,
      'ProductID': productID,
      'ProductCode': productCode,
      'ProductName': productName,
      'ProductEnName': productEnName,
      'SalesQuantity': salesQuantity,
      'BarCode': barCode,
      'CustomerPhone': customerPhone,
      'Specifications': specifications,
      'DiscountPercent': discountPercent,
      'ProductImage': productImage,
      'StockQuantity': stockQuantity,
      'Price': price,
      'CustomerQuantity': customerQuantity,
      'TotalQuantity': totalQuantity,
      'RequiredQTY': requiredQTY,
      'GiftQTY': giftQTY,
      'Y_Gift_Qty': yGiftQty,
      'CategoryId': categoryId,
      'Description1': description1,
      'Description2': description2,
      'priceBeforeDiscount': priceBeforeDiscount,
      'priceAfterDiscount': priceAfterDiscount,
    };
  }

  @override
  List<Object?> get props => [
    customerID,
    customerName,
    customerEName,
    productID,
    productCode,
    productName,
    productEnName,
    salesQuantity,
    barCode,
    customerPhone,
    specifications,
    discountPercent,
    productImage,
    stockQuantity,
    price,
    customerQuantity,
    totalQuantity,
    requiredQTY,
    giftQTY,
    yGiftQty,
    categoryId,
    description1,
    description2,
    priceBeforeDiscount,
    priceAfterDiscount,
  ];
}

extension BasketItemModelExtension on BasketItemModel {

  double get totalSplitPrice {
    final hasDiscount = priceAfterDiscount > 0 && priceAfterDiscount < price;
    if (hasDiscount && customerQuantity > 0) {
      final discountQty = salesQuantity > customerQuantity
          ? customerQuantity
          : salesQuantity.toDouble();
      final normalQty = salesQuantity - discountQty;
      return (discountQty * priceAfterDiscount) + (normalQty * price);
    }
    return (priceAfterDiscount > 0 ? priceAfterDiscount : price) * salesQuantity;
  }

  BasketItemModel copyWith({
    int? customerID,
    String? customerName,
    String? customerEName,
    int? productID,
    String? productCode,
    String? productName,
    String? productEnName,
    int? salesQuantity,
    String? barCode,
    String? customerPhone,
    String? specifications,
    int? discountPercent,
    String? productImage,
    double? stockQuantity,
    double? price,
    double? customerQuantity,
    double? totalQuantity,
    int? requiredQTY,
    int? giftQTY,
    int? yGiftQty,
    int? categoryId,
    String? description1,
    double? priceBeforeDiscount,
    double? priceAfterDiscount,
  }) {
    return BasketItemModel(
      customerID: customerID ?? this.customerID,
      customerName: customerName ?? this.customerName,
      customerEName: customerEName ?? this.customerEName,
      productID: productID ?? this.productID,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      productEnName: productEnName ?? this.productEnName,
      salesQuantity: salesQuantity ?? this.salesQuantity,
      barCode: barCode ?? this.barCode,
      customerPhone: customerPhone ?? this.customerPhone,
      specifications: specifications ?? this.specifications,
      discountPercent: discountPercent ?? this.discountPercent,
      productImage: productImage ?? this.productImage,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      price: price ?? this.price,
      customerQuantity: customerQuantity ?? this.customerQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      requiredQTY: requiredQTY ?? this.requiredQTY,
      giftQTY: giftQTY ?? this.giftQTY,
      yGiftQty: yGiftQty ?? this.yGiftQty,
      categoryId: categoryId ?? this.categoryId,
      description1: description1 ?? this.description1,
      priceBeforeDiscount: priceBeforeDiscount ?? this.priceBeforeDiscount,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
    );
  }
}
