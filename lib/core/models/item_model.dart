import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'item_model.g.dart';

@HiveType(typeId: 2)
enum BadgeType {
  @HiveField(0)
  offer,
  @HiveField(1)
  outOfStock,
  @HiveField(2)
  none,
}

@HiveType(typeId: 3)
class ItemModel extends Equatable {

  @HiveField(0)
  final String productCode;
  @HiveField(1)
  final String barCode;
  @HiveField(2)
  final String? colorArName;
  @HiveField(3)
  final String? colorEnName;
  @HiveField(4)
  final String? sizeName;
  @HiveField(5)
  final String? sizeEName;
  @HiveField(6)
  final String productArName;
  @HiveField(7)
  final String productEnName;
  @HiveField(8)
  final String categoryArName;
  @HiveField(12)
  final String categoryEnName;
  @HiveField(13)
  final String? productImage;
  @HiveField(14)
  final bool isFavorite;
  @HiveField(15)
  final double price;
  @HiveField(16)
  final num stockQuantity;
  @HiveField(17)
  final String? categoryId;
  @HiveField(18)
  final double priceAfterDiscount;
  @HiveField(19)
  final String registrationDate;
  @HiveField(20)
  final int productId;
  @HiveField(21)
  final String? description1;
  @HiveField(22)
  final String? description2;
  @HiveField(23)
  final String? description3;
  @HiveField(24)
  final String? description4;
  @HiveField(25)
  final String? description5;
  @HiveField(26)
  final String? description6;
  @HiveField(27)
  final String? description7;
  @HiveField(28)
  final String? description8;
  @HiveField(29)
  final String? description9;
  @HiveField(30)
  final String? description10;
  @HiveField(31)
  final String? defaultUnitArName;
  @HiveField(32)
  final String? defaultUnitEnName;
  @HiveField(33)
  final num? unitValue;
  @HiveField(34)
  final String? unitArName;
  @HiveField(35)
  final String? unitEnName;
  @HiveField(36)
  final String? brandID;
  @HiveField(37)
  final double? customerQuantity;
  @HiveField(38)
  final int salesQuantity;

  const ItemModel({
    required this.productCode,
    required this.barCode,
    this.colorArName,
    this.colorEnName,
    this.sizeName,
    this.sizeEName,
    required this.productId,
    required this.productArName,
    required this.productEnName,
    required this.categoryArName,
    required this.categoryEnName,
    this.productImage,
    required this.isFavorite,
    required this.price,
    required this.priceAfterDiscount,
    required this.registrationDate,
    required this.stockQuantity,
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
    this.categoryId,
    this.defaultUnitEnName,
    this.defaultUnitArName,
    this.unitValue,
    this.unitEnName,
    this.unitArName,
    this.brandID,
    this.customerQuantity,
    this.salesQuantity = 0,
  });

  const ItemModel.empty()
      : productCode = '',
        barCode = '',
        colorArName = null,
        colorEnName = null,
        sizeName = null,
        sizeEName = null,
        productId = 0,
        productArName = '',
        productEnName = '',
        categoryArName = '',
        categoryEnName = '',
        productImage = null,
        isFavorite = false,
        price = 0.0,
        priceAfterDiscount = 0.0,
        registrationDate = '',
        stockQuantity = 0,
        description1 = null,
        description2 = null,
        description3 = null,
        description4 = null,
        description5 = null,
        description6 = null,
        description7 = null,
        description8 = null,
        description9 = null,
        description10 = null,
        categoryId = null,
        defaultUnitArName = null,
        defaultUnitEnName = null,
        unitValue = null,
        unitArName = null,
        unitEnName = null,
        customerQuantity = 0.0,
        salesQuantity = 0,
        brandID = null;


  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      productCode: json['ProductCode'] ?? '',
      productId: json["ProductID"] ?? 0,
      barCode: json['BarCode'] ?? '',
      colorArName: json['ColorArName'] ?? '',
      colorEnName: json['ColorEnName'],
      sizeName: json['SizeName'],
      categoryId: json['CategoryId'] ?? "",
      sizeEName: json['SizeEName'] ?? '',
      customerQuantity: json['CustomerQuantity'] ?? 0.0,
      productArName: (() {
        final mainName = json['ProductArName'] ?? json['ProductName'] ?? '';
        final unit = (json['DefaultUnitArName'] ?? json['UnitArName'] ?? '');
        return unit != null && unit.toString().isNotEmpty
            ? '$mainName ($unit)'
            : mainName;
      })(),

      productEnName: (() {
        final mainName = json['ProductEnName'] ?? json['ProductEnName'] ?? '';

        final unit = (json['DefaultUnitEnName'] ?? json['UnitEnName'] ?? '');
        return unit != null && unit.toString().isNotEmpty
            ? '$mainName ($unit)'
            : mainName;
      })(),

      unitArName: json['UnitArName'] ?? '',
      unitEnName: json['UnitEnName'] ?? '',
      defaultUnitArName: json['DefaultUnitArName'] ?? 'unit'.tr(),
      defaultUnitEnName: json['DefaultUnitEnName'] ?? 'unit'.tr(),
      unitValue: json['UnitValue'] ?? '',

      categoryArName: json['CategoryArName'] ?? '',
      categoryEnName: json['CategoryEnName'] ?? '',
      productImage: json['ProductcImage'] ?? '',
      isFavorite: json['IsFavorite'] == 1,
      stockQuantity: json['StockQuantity'] ?? 0.0,
      price: json['Price'] ?? 0.0,
      priceAfterDiscount: json['PriceAfterDiscount'] ?? 0.0,
      registrationDate: json['RegisterationDate'] ?? '',
      description1: json['Description1'] ?? '',
      description2: json['Description2'] ?? '',
      description3: json['Description3'] ?? '',
      description4: json['Description4'] ?? '',
      description5: json['Description5'] ?? '',
      description6: json['Description6'] ?? '',
      description7: json['Description7'] ?? '',
      description8: json['Description8'] ?? '',
      description9: json['Description9'] ?? '',
      description10: json['Description10'] ?? '',
      brandID: json['BrandID'] ?? '',
      salesQuantity: json['SalesQuantity'] ?? 0,
    );
  }

  ItemModel copyWith({
    String? productCode,
    String? barCode,
    String? colorArName,
    String? colorEnName,
    String? sizeName,
    String? sizeEName,
    int? productId,
    String? productArName,
    String? productEnName,
    String? categoryArName,
    String? categoryEnName,
    String? productImage,
    bool? isFavorite,
    double? price,
    double? priceAfterDiscount,
    String? registrationDate,
    num? stockQuantity,
    String? description1,
    String? description2,
    String? description3,
    String? description4,
    String? description5,
    String? description6,
    String? description7,
    String? description8,
    String? description9,
    String? description10,
    String? categoryId,
    String? defaultUnitArName,
    String? defaultUnitEnName,
    num? unitValue,
    String? unitArName,
    String? unitEnName,
    String? brandID,
    double? customerQuantity,
    int? salesQuantity,
  }) {
    return ItemModel(
      productCode: productCode ?? this.productCode,
      barCode: barCode ?? this.barCode,
      colorArName: colorArName ?? this.colorArName,
      colorEnName: colorEnName ?? this.colorEnName,
      sizeName: sizeName ?? this.sizeName,
      sizeEName: sizeEName ?? this.sizeEName,
      productId: productId ?? this.productId,
      productArName: productArName ?? this.productArName,
      productEnName: productEnName ?? this.productEnName,
      categoryArName: categoryArName ?? this.categoryArName,
      categoryEnName: categoryEnName ?? this.categoryEnName,
      productImage: productImage ?? this.productImage,
      isFavorite: isFavorite ?? this.isFavorite,
      price: price ?? this.price,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      registrationDate: registrationDate ?? this.registrationDate,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      description1: description1 ?? this.description1,
      description2: description2 ?? this.description2,
      description3: description3 ?? this.description3,
      description4: description4 ?? this.description4,
      description5: description5 ?? this.description5,
      description6: description6 ?? this.description6,
      description7: description7 ?? this.description7,
      description8: description8 ?? this.description8,
      description9: description9 ?? this.description9,
      description10: description10 ?? this.description10,
      categoryId: categoryId ?? this.categoryId,
      defaultUnitArName: defaultUnitArName ?? this.defaultUnitArName,
      defaultUnitEnName: defaultUnitEnName ?? this.defaultUnitEnName,
      unitValue: unitValue ?? this.unitValue,
      unitArName: unitArName ?? this.unitArName,
      unitEnName: unitEnName ?? this.unitEnName,
      brandID: brandID ?? this.brandID,
      customerQuantity: customerQuantity ?? this.customerQuantity,
      salesQuantity: salesQuantity ?? this.salesQuantity,
    );
  }

  String displayInfo() {
    return '''
ProductID: $productId
ProductCode: $productCode
BarCode: $barCode
ProductArName: $productArName
ProductEnName: $productEnName
CategoryArName: $categoryArName
CategoryEnName: $categoryEnName
ColorArName: $colorArName
ColorEnName: $colorEnName
SizeName: $sizeName
SizeEName: $sizeEName
StockQuantity: $stockQuantity
Price: $price
PriceAfterDiscount: $priceAfterDiscount
IsFavorite: $isFavorite
ProductImage: $productImage
RegistrationDate: $registrationDate
Descriptions: [$description1, $description2, $description3, $description4, $description5, $description6, $description7, $description8, $description9, $description10]
DefaultUnitArName: $defaultUnitArName
DefaultUnitEnName: $defaultUnitEnName
UnitValue: $unitValue
UnitArName: $unitArName
UnitEnName: $unitEnName
BrandID: $brandID
CustomerQuantity: $customerQuantity
SalesQuantity: $salesQuantity
''';
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductCode': productCode,
      'ProductID': productId,
      'BarCode': barCode,
      'ColorArName': colorArName,
      'ColorEnName': colorEnName,
      'SizeName': sizeName,
      'SizeEName': sizeEName,
      'ProductArName': productArName,
      'ProductEnName': productEnName,
      'CategoryArName': categoryArName,
      'CategoryEnName': categoryEnName,
      'ProductcImage': productImage,
      'IsFavorite': isFavorite ? 1 : 0, // تحويل bool إلى int
      'Price': price,
      'PriceAfterDiscount': priceAfterDiscount,
      'StockQuantity': stockQuantity,
      'RegisterationDate': registrationDate,
      'CategoryId': categoryId,
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
      'UnitArName': unitArName,
      'UnitEnName': unitEnName,
      'BrandID': brandID,
      'CustomerQuantity': customerQuantity,
      'SalesQuantity': salesQuantity,
    };
  }

  bool get isOutOfStock => (stockQuantity) <= 0;

  double? get offerPercentage {
    if (price > 0 && priceAfterDiscount < price) {
      final discount = price - priceAfterDiscount;
      final percentage = (discount / price) * 100;
      return percentage.roundToDouble();
    }
    return null;
  }

  BadgeType get initialBadgeType {
    if (isOutOfStock) {
      return BadgeType.outOfStock;
    } else if (offerPercentage != null && offerPercentage! > 0) {
      return BadgeType.offer;
    } else {
      return BadgeType.none;
    }
  }

  @override
  List<Object?> get props => [
    productCode,
    barCode,
    colorArName,
    colorEnName,
    sizeName,
    sizeEName,
    productArName,
    productEnName,
    categoryArName,
    categoryEnName,
    productImage,
    isFavorite,
    price,
    stockQuantity,
    categoryId,
    priceAfterDiscount,
    registrationDate,
    productId,
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
    unitValue,
    unitArName,
    unitEnName,
    brandID,
    customerQuantity,
    salesQuantity,
  ];

  double get totalSplitPrice {
    final hasDiscount = priceAfterDiscount > 0 && priceAfterDiscount < price;
    if (hasDiscount && (customerQuantity ?? 0) > 0) {
      final discountLimit = customerQuantity ?? 0;
      final discountQty = salesQuantity > discountLimit
          ? discountLimit
          : salesQuantity.toDouble();
      final normalQty = salesQuantity - discountQty;
      return (discountQty * priceAfterDiscount) + (normalQty * price);
    }
    return (priceAfterDiscount > 0 ? priceAfterDiscount : price) * salesQuantity;
  }
}
