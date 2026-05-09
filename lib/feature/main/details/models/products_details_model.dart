import 'package:equatable/equatable.dart';

/// Model for product unit/price variations
class ProductUnitModel extends Equatable {
  final num productId;
  final String barcode;
  final String imagePath;
  final num unitNumber;
  final num unitId;
  final String unitArName;
  final String unitEnName;
  final num price;
  final num priceAfterDiscount;
  final num discountRate;
  final num giftQty;
  final num requiredQty;
  final num stockQty;
  final num customerQuantity;
  final num totalQuantity;
  final num yGiftQty;
  final String productArName;
  final String productEnName;
  final String categoryId;
  final num unitValue;
  final num customerQtyFree;
  final num totalQtyFree;

  const ProductUnitModel({
    required this.productId,
    required this.barcode,
    required this.imagePath,
    required this.unitNumber,
    required this.unitId,
    required this.unitArName,
    required this.unitEnName,
    required this.price,
    required this.priceAfterDiscount,
    required this.discountRate,
    required this.giftQty,
    required this.requiredQty,
    required this.stockQty,
    required this.customerQuantity,
    required this.totalQuantity,
    required this.yGiftQty,
    required this.productArName,
    required this.productEnName,
    required this.categoryId,
    required this.unitValue,
    required this.customerQtyFree,
    required this.totalQtyFree,
  });

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) {
    return ProductUnitModel(
      productId: json['ProductID'] ?? 0,
      barcode: json['Barcode'] ?? '',
      imagePath: json['ImagePath'] ?? '',
      unitNumber: json['UnitNumber'] ?? 0,
      unitId: json['UnitID'] ?? 0,
      unitArName: json['UnitArName'] ?? '',
      unitEnName: json['UnitEnName'] ?? '',
      price: (json['Price'] ?? 0).toDouble(),
      priceAfterDiscount: (json['PriceAfterDiscount'] ?? 0).toDouble(),
      discountRate: (json['DiscountRate'] ?? 0).toDouble(),
      giftQty: json['GiftQTY'] ?? 0,
      requiredQty: json['RequiredQTY'] ?? 1,
      stockQty: json['StockQty'] ?? 0,
      customerQuantity: (json['CustomerQuantity'] ?? 0).toDouble(),
      totalQuantity: json['TotalQuantity'] ?? 0,
      yGiftQty: json['Y_Gift_Qty'] ?? 0,
      productArName: json['ProductArName'] ?? '',
      productEnName: json['ProductEnName'] ?? '',
      categoryId: json['CategoryId'] ?? '',
      unitValue: json['UnitValue'] ?? 0,
      customerQtyFree: json['CustomerQtyFree'] ?? 0,
      totalQtyFree: json['TotalQtyFree'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductID': productId,
      'Barcode': barcode,
      'ImagePath': imagePath,
      'UnitNumber': unitNumber,
      'UnitID': unitId,
      'UnitArName': unitArName,
      'UnitEnName': unitEnName,
      'Price': price,
      'PriceAfterDiscount': priceAfterDiscount,
      'DiscountRate': discountRate,
      'GiftQTY': giftQty,
      'RequiredQTY': requiredQty,
      'StockQty': stockQty,
      'CustomerQuantity': customerQuantity,
      'TotalQuantity': totalQuantity,
      'Y_Gift_Qty': yGiftQty,
      'ProductArName': productArName,
      'ProductEnName': productEnName,
      'CategoryId': categoryId,
      'UnitValue': unitValue,
      'CustomerQtyFree': customerQtyFree,
      'TotalQtyFree': totalQtyFree,
    };
  }

  @override
  List<Object?> get props => [
    productId,
    barcode,
    unitNumber,
    unitId,
    price,
    priceAfterDiscount,
    stockQty,
    customerQuantity,
    totalQuantity,
    yGiftQty,
    productArName,
    productEnName,
    categoryId,
    unitValue,
    customerQtyFree,
    totalQtyFree,
  ];
}

/// Main Product Details Model
class ProductDetailsModel extends Equatable {
  final String productCode;
  final String barCode;
  final String? colorArName;
  final String? colorEnName;
  final String? sizeName;
  final String? sizeEName;
  final String productArName;
  final String productEnName;
  final String categoryId;
  final String categoryArName;
  final String categoryEnName;
  final num stockQuantity;
  final double price;
  final double priceAfterDiscount;
  final String? specification;
  final int productId;
  final String? productImage;
  final String? productImage2;
  final int isFavorite;
  final String? description1;
  final String? description2;
  final String? description3;
  final String? description4;
  final String? description5;
  final String? description6;
  final String? description7;
  final String? description8;
  final String? description9;
  final String? description10;
  final String? defaultUnitArName;
  final String? defaultUnitEnName;
  final num unitValue;
  final String? brandId;
  final List<ProductUnitModel> productImages;

  const ProductDetailsModel({
    required this.productCode,
    required this.barCode,
    this.colorArName,
    this.colorEnName,
    this.sizeName,
    this.sizeEName,
    required this.productArName,
    required this.productEnName,
    required this.categoryId,
    required this.categoryArName,
    required this.categoryEnName,
    required this.stockQuantity,
    required this.price,
    required this.priceAfterDiscount,
    this.specification,
    required this.productId,
    this.productImage,
    this.productImage2,
    required this.isFavorite,
    this.description1,
    this.description2,
    this.description3,
    this.description4,
    this.description5,
    this.description6,
    this.description7,
    this.description8,
    this.description9,
    this.description10,
    this.defaultUnitArName,
    this.defaultUnitEnName,
    required this.unitValue,
    this.brandId,
    required this.productImages,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final productImagesList = json['Product_Images'] as List<dynamic>? ?? [];
    final units = productImagesList
        .map((e) => ProductUnitModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProductDetailsModel(
      productCode: json['ProductCode'] ?? '',
      barCode: json['BarCode'] ?? '',
      colorArName: json['ColorArName'] ,
      colorEnName: json['ColorEnName'],
      sizeName: json['SizeName'],
      sizeEName: json['SizeEName'],
      productArName: json['ProductArName'] ?? '',
      productEnName: json['ProductEnName'] ?? '',
      categoryId: json['CategoryId'] ?? '',
      categoryArName: json['CategoryArName'] ?? '',
      categoryEnName: json['CategoryEnName'] ?? '',
      stockQuantity: json['StockQuantity'] ?? 0,
      price: (json['Price'] ?? 0).toDouble(),
      priceAfterDiscount: (json['PriceAfterDiscount'] ?? 0).toDouble(),
      specification: json['Specification'],
      productId: json['ProductID'] ?? 0,
      productImage: json['ProductcImage'],
      productImage2: json['ProductcImage2'],
      isFavorite: json['IsFavorite'] ?? 0,
      description1: json['Description1'],
      description2: json['Description2'],
      description3: json['Description3'],
      description4: json['Description4'],
      description5: json['Description5'],
      description6: json['Description6'],
      description7: json['Description7'],
      description8: json['Description8'],
      description9: json['Description9'],
      description10: json['Description10'],
      defaultUnitArName: json['DefaultUnitArName'],
      defaultUnitEnName: json['DefaultUnitEnName'],
      unitValue: json['UnitValue'] ?? 0,
      brandId: json['BrandID'],
      productImages: units,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductCode': productCode,
      'BarCode': barCode,
      'ColorArName': colorArName,
      'ColorEnName': colorEnName,
      'SizeName': sizeName,
      'SizeEName': sizeEName,
      'ProductArName': productArName,
      'ProductEnName': productEnName,
      'CategoryId': categoryId,
      'CategoryArName': categoryArName,
      'CategoryEnName': categoryEnName,
      'StockQuantity': stockQuantity,
      'Price': price,
      'PriceAfterDiscount': priceAfterDiscount,
      'Specification': specification,
      'ProductID': productId,
      'ProductcImage': productImage,
      'ProductcImage2': productImage2,
      'IsFavorite': isFavorite,
      'Description1': description1,
      'Description2': description2,
      'Description3': description3,
      'Description4': description4,
      'Description5': description5,
      'Description6': description6,
      'Description7': description7,
      'Description8': description8,
      'Description9': description9,
      'Description10': description10,
      'DefaultUnitArName': defaultUnitArName,
      'DefaultUnitEnName': defaultUnitEnName,
      'UnitValue': unitValue,
      'BrandID': brandId,
      'Product_Images': productImages.map((e) => e.toJson()).toList(),
    };
  }

  bool get isOutOfStock => stockQuantity <= 0;

  bool get isFavoriteItem => isFavorite == 1;

  double? get offerPercentage {
    if (price > 0 && priceAfterDiscount < price) {
      final discount = price - priceAfterDiscount;
      final percentage = (discount / price) * 100;
      return percentage.roundToDouble();
    }
    return null;
  }

  @override
  List<Object?> get props => [
    productCode,
    barCode,
    productId,
    productArName,
    productEnName,
    categoryId,
    price,
    priceAfterDiscount,
    stockQuantity,
    isFavorite,
    productImages,
    productArName,
    productEnName,
    categoryId,
    unitValue,
    brandId,
    description1,
    description2,
    description3,
    description4,
    description5,
    description6,
    description7,
    description8,
    description9,
    description10,
    defaultUnitArName,
    defaultUnitEnName,
    specification,
    colorArName,
    colorEnName,
    sizeName,
    sizeEName,
    brandId,
    specification,
    isFavorite,
    productImage,
    productImage2,
    productImages,
    unitValue,
    colorArName,
    colorEnName,
    sizeName,
    sizeEName,
    brandId,
    specification,
    isFavorite,
    productImage,
    productImages,
    unitValue,

  ];


  ProductDetailsModel.empty() : this(categoryArName: "",
    categoryEnName: "",
    productCode: '',
    barCode: '',
    productId: 0,
    productArName: '',
    productEnName: '',
    categoryId: "0",
    price: 0,
    priceAfterDiscount: 0,
    stockQuantity: 0,
    isFavorite: 0,
    productImages: [],

    unitValue: 0,

    description1: '',
    description2: '',
    description3: '',
    description4: '',
    description5: '',
    description6: '',
    description7: '',
    description8: '',
    description9: '',
    description10: '',
    defaultUnitArName: '',
    defaultUnitEnName: '',
    specification: '',
    colorArName: '',
    colorEnName: '',
    sizeName: '',
    sizeEName: '',

    productImage: '',
    productImage2: '',
  );
}