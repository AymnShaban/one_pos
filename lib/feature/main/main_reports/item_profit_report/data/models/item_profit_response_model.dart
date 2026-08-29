import '../../item_profit_import.dart';
class ItemProfitResponseModel extends Equatable {
  final String startDate;
  final String endDate;
  final List<BranchGroupModel> branchGroups;
  final double totalQty;
  final double totalValue;
  final double totalCost;
  final double totalProfit;

  const ItemProfitResponseModel({
    required this.startDate,
    required this.endDate,
    required this.branchGroups,
    required this.totalQty,
    required this.totalValue,
    required this.totalCost,
    required this.totalProfit,
  });

  factory ItemProfitResponseModel.fromJson(Map<String, dynamic> json) {
    return ItemProfitResponseModel(
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      branchGroups: (json['branchGroups'] as List?)
          ?.map((e) => BranchGroupModel.fromJson(e))
          .toList() ?? [],
      totalQty: (json['totalQty'] ?? 0).toDouble(),
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      totalCost: (json['totalCost'] ?? 0).toDouble(),
      totalProfit: (json['totalProfit'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'branchGroups': branchGroups.map((e) => e.toJson()).toList(),
      'totalQty': totalQty,
      'totalValue': totalValue,
      'totalCost': totalCost,
      'totalProfit': totalProfit,
    };
  }

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    branchGroups,
    totalQty,
    totalValue,
    totalCost,
    totalProfit,
  ];
}

class BranchGroupModel extends Equatable {
  final int branchId;
  final String branchName;
  final List<BillModel> bills;
  final double totalQty;
  final double totalValue;
  final double totalCost;
  final double totalProfit;

  const BranchGroupModel({
    required this.branchId,
    required this.branchName,
    required this.bills,
    required this.totalQty,
    required this.totalValue,
    required this.totalCost,
    required this.totalProfit,
  });

  factory BranchGroupModel.fromJson(Map<String, dynamic> json) {
    return BranchGroupModel(
      branchId: json['branchId'] ?? 0,
      branchName: json['branchName'] ?? '',
      bills: (json['bills'] as List?)
          ?.map((e) => BillModel.fromJson(e))
          .toList() ?? [],
      totalQty: (json['totalQty'] ?? 0).toDouble(),
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      totalCost: (json['totalCost'] ?? 0).toDouble(),
      totalProfit: (json['totalProfit'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'bills': bills.map((e) => e.toJson()).toList(),
      'totalQty': totalQty,
      'totalValue': totalValue,
      'totalCost': totalCost,
      'totalProfit': totalProfit,
    };
  }

  @override
  List<Object?> get props => [
    branchId,
    branchName,
    bills,
    totalQty,
    totalValue,
    totalCost,
    totalProfit,
  ];
}

class BillModel extends Equatable {
  final int billId;
  final int blNo;
  final String blDate;
  final String dateDisplay;
  final String billType;
  final int supposeType;
  final bool isReturn;
  final String customerName;
  final String customerCode;
  final String branchName;
  final String payWayType;
  final double totalQty;
  final int billNumber;
  final double disc;
  final double extra;
  final double billValue;
  final int branchId;
  final List<ItemProfitItemModel> items;

  const BillModel({
    required this.billId,
    required this.blNo,
    required this.blDate,
    required this.dateDisplay,
    required this.billType,
    required this.supposeType,
    required this.isReturn,
    required this.customerName,
    required this.customerCode,
    required this.branchName,
    required this.payWayType,
    required this.totalQty,
    required this.billNumber,
    required this.disc,
    required this.extra,
    required this.billValue,
    required this.branchId,
    required this.items,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      billId: json['billId'] ?? 0,
      blNo: json['blNo'] ?? 0,
      blDate: json['blDate'] ?? '',
      dateDisplay: json['dateDisplay'] ?? '',
      billType: json['billType'] ?? '',
      supposeType: json['supposeType'] ?? 0,
      isReturn: json['isReturn'] ?? false,
      customerName: json['customerName'] ?? '',
      customerCode: json['customerCode'] ?? '',
      branchName: json['branchName'] ?? '',
      payWayType: json['payWayType'] ?? '',
      totalQty: (json['totalQty'] ?? 0).toDouble(),
      billNumber: json['billNumber'] ?? 0,
      disc: (json['disc'] ?? 0).toDouble(),
      extra: (json['extra'] ?? 0).toDouble(),
      billValue: (json['billValue'] ?? 0).toDouble(),
      branchId: json['branchId'] ?? 0,
      items: (json['items'] as List?)
          ?.map((e) => ItemProfitItemModel.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billId': billId,
      'blNo': blNo,
      'blDate': blDate,
      'dateDisplay': dateDisplay,
      'billType': billType,
      'supposeType': supposeType,
      'isReturn': isReturn,
      'customerName': customerName,
      'customerCode': customerCode,
      'branchName': branchName,
      'payWayType': payWayType,
      'totalQty': totalQty,
      'billNumber': billNumber,
      'disc': disc,
      'extra': extra,
      'billValue': billValue,
      'branchId': branchId,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    billId,
    blNo,
    blDate,
    dateDisplay,
    billType,
    supposeType,
    isReturn,
    customerName,
    customerCode,
    branchName,
    payWayType,
    totalQty,
    billNumber,
    disc,
    extra,
    billValue,
    branchId,
    items,
  ];
}

class ItemProfitItemModel extends Equatable {
  final int blNo;
  final int matId;
  final String matName;
  final String matEName;
  final double qty;
  final String unit;
  final double price;
  final double total;
  final double discount;
  final double costPrice;
  final double totalCost;
  final double profit;
  final double totalProfit;
  final String notes;
  final String billArName;
  final int supposeType;
  final String serials;

  const ItemProfitItemModel({
    required this.blNo,
    required this.matId,
    required this.matName,
    required this.matEName,
    required this.qty,
    required this.unit,
    required this.price,
    required this.total,
    required this.discount,
    required this.costPrice,
    required this.totalCost,
    required this.profit,
    required this.totalProfit,
    required this.notes,
    required this.billArName,
    required this.supposeType,
    required this.serials,
  });

  factory ItemProfitItemModel.fromJson(Map<String, dynamic> json) {
    return ItemProfitItemModel(
      blNo: json['blNo'] ?? 0,
      matId: json['matId'] ?? 0,
      matName: json['matName'] ?? '',
      matEName: json['matEName'] ?? '',
      qty: (json['qty'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      costPrice: (json['costPrice'] ?? 0).toDouble(),
      totalCost: (json['totalCost'] ?? 0).toDouble(),
      profit: (json['profit'] ?? 0).toDouble(),
      totalProfit: (json['totalProfit'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      billArName: json['billArName'] ?? '',
      supposeType: json['supposeType'] ?? 0,
      serials: json['serials'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blNo': blNo,
      'matId': matId,
      'matName': matName,
      'matEName': matEName,
      'qty': qty,
      'unit': unit,
      'price': price,
      'total': total,
      'discount': discount,
      'costPrice': costPrice,
      'totalCost': totalCost,
      'profit': profit,
      'totalProfit': totalProfit,
      'notes': notes,
      'billArName': billArName,
      'supposeType': supposeType,
      'serials': serials,
    };
  }

  @override
  List<Object?> get props => [
    blNo,
    matId,
    matName,
    matEName,
    qty,
    unit,
    price,
    total,
    discount,
    costPrice,
    totalCost,
    profit,
    totalProfit,
    notes,
    billArName,
    supposeType,
    serials,
  ];
}