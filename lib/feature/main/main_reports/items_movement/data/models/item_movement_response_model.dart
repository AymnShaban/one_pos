class ItemMovementResponseModel {
  final bool success;
  final String? message;
  final List<ItemMovementItemModel> items;

  const ItemMovementResponseModel({
    required this.success,
    this.message,
    required this.items,
  });

  factory ItemMovementResponseModel.fromJson(Map<String, dynamic> json) {
    return ItemMovementResponseModel(
      success: json['success'] ?? false,
      message: json['message'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) => ItemMovementItemModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
class ItemMovementItemModel {
  final String materialId;
  final String materialName;
  final List<ItemMovementRowModel> rows;

  final double? maxPurchase;
  final double? minPurchase;
  final double? avgPurchase;

  final double? maxSell;
  final double? minSell;
  final double? avgSell;

  final double? totalInQty;
  final double? totalOutQty;
  final double? finalBalance;

  const ItemMovementItemModel({
    required this.materialId,
    required this.materialName,
    required this.rows,
    this.maxPurchase,
    this.minPurchase,
    this.avgPurchase,
    this.maxSell,
    this.minSell,
    this.avgSell,
    this.totalInQty,
    this.totalOutQty,
    this.finalBalance,
  });

  factory ItemMovementItemModel.fromJson(Map<String, dynamic> json) {
    return ItemMovementItemModel(
      materialId: json['materialId']?.toString() ?? '',
      materialName: json['materialName']?.toString() ?? '',
      rows: (json['rows'] as List<dynamic>?)
          ?.map(
            (row) => ItemMovementRowModel.fromJson(
          row as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],
      maxPurchase: (json['maxPurchase'] as num?)?.toDouble(),
      minPurchase: (json['minPurchase'] as num?)?.toDouble(),
      avgPurchase: (json['avgPurchase'] as num?)?.toDouble(),
      maxSell: (json['maxSell'] as num?)?.toDouble(),
      minSell: (json['minSell'] as num?)?.toDouble(),
      avgSell: (json['avgSell'] as num?)?.toDouble(),
      totalInQty: (json['totalInQty'] as num?)?.toDouble(),
      totalOutQty: (json['totalOutQty'] as num?)?.toDouble(),
      finalBalance: (json['finalBalance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materialId': materialId,
      'materialName': materialName,
      'rows': rows.map((row) => row.toJson()).toList(),
      'maxPurchase': maxPurchase,
      'minPurchase': minPurchase,
      'avgPurchase': avgPurchase,
      'maxSell': maxSell,
      'minSell': minSell,
      'avgSell': avgSell,
      'totalInQty': totalInQty,
      'totalOutQty': totalOutQty,
      'finalBalance': finalBalance,
    };
  }
}

class ItemMovementRowModel {
  final String date;
  final String billName;
  final int? number;

  final double? qty1;
  final double? price1;
  final double? total1;

  final double? qty2;
  final double? price2;
  final double? total2;

  final double? qty3;
  final double? price3;
  final double? total3;

  final String store;
  final String employee;
  final String customer;
  final String costCenter;
  final String category;
  final String itemSerials;
  final String expireDate;
  final String explanationItem;
  final String notes;

  final int? billSupposeType;
  final bool isPosted;

  const ItemMovementRowModel({
    required this.date,
    required this.billName,
    this.number,
    this.qty1,
    this.price1,
    this.total1,
    this.qty2,
    this.price2,
    this.total2,
    this.qty3,
    this.price3,
    this.total3,
    required this.store,
    required this.employee,
    required this.customer,
    required this.costCenter,
    required this.category,
    required this.itemSerials,
    required this.expireDate,
    required this.explanationItem,
    required this.notes,
    this.billSupposeType,
    required this.isPosted,
  });

  factory ItemMovementRowModel.fromJson(Map<String, dynamic> json) {
    return ItemMovementRowModel(
      date: json['date']?.toString() ?? '',
      billName: json['billName']?.toString() ?? '',
      number: (json['number'] as num?)?.toInt(),

      qty1: (json['qty1'] as num?)?.toDouble(),
      price1: (json['price1'] as num?)?.toDouble(),
      total1: (json['total1'] as num?)?.toDouble(),

      qty2: (json['qty2'] as num?)?.toDouble(),
      price2: (json['price2'] as num?)?.toDouble(),
      total2: (json['total2'] as num?)?.toDouble(),

      qty3: (json['qty3'] as num?)?.toDouble(),
      price3: (json['price3'] as num?)?.toDouble(),
      total3: (json['total3'] as num?)?.toDouble(),

      store: json['store']?.toString() ?? '',
      employee: json['employee']?.toString() ?? '',
      customer: json['customer']?.toString() ?? '',
      costCenter: json['costCenter']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      itemSerials: json['itemSerials']?.toString() ?? '',
      expireDate: json['expireDate']?.toString() ?? '',
      explanationItem: json['explanationItem']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',

      billSupposeType: (json['billSupposeType'] as num?)?.toInt(),
      isPosted: json['isPosted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'billName': billName,
      'number': number,

      'qty1': qty1,
      'price1': price1,
      'total1': total1,

      'qty2': qty2,
      'price2': price2,
      'total2': total2,

      'qty3': qty3,
      'price3': price3,
      'total3': total3,

      'store': store,
      'employee': employee,
      'customer': customer,
      'costCenter': costCenter,
      'category': category,
      'itemSerials': itemSerials,
      'expireDate': expireDate,
      'explanationItem': explanationItem,
      'notes': notes,

      'billSupposeType': billSupposeType,
      'isPosted': isPosted,
    };
  }
}