part of '../new_invoice_imports.dart';

/// Full invoice payload returned by GetInvoiceForEdit. Only the fields the
/// details screen actually renders are parsed; the many null accounting /
/// internal fields on the API response are ignored.
class InvoiceDetailsModel extends Equatable {
  final int invoiceId;
  final int invoiceNo;
  final DateTime? invoiceDate;
  final int? invoiceTypeId;
  final String? customerName;
  final int payingType;
  final double totalValue;
  final double totalDiscount;
  final double totalAddition;
  final double finalValue;
  final String? createdBy;
  final int? companyBranchId;
  final String? companyBranchName;
  final bool taxBill;
  final String? currencySymbol;
  final List<InvoiceDetailsItem> items;
  final List<InvoiceDetailsPayWay> payWays;
  final List<InvoiceDetailsDiscount> discounts;

  const InvoiceDetailsModel({
    required this.invoiceId,
    required this.invoiceNo,
    this.invoiceDate,
    this.invoiceTypeId,
    this.customerName,
    this.payingType = 0,
    this.totalValue = 0,
    this.totalDiscount = 0,
    this.totalAddition = 0,
    this.finalValue = 0,
    this.createdBy,
    this.companyBranchId,
    this.companyBranchName,
    this.taxBill = false,
    this.currencySymbol,
    this.items = const [],
    this.payWays = const [],
    this.discounts = const [],
  });

  factory InvoiceDetailsModel.fromJson(Map<String, dynamic> json) {
    List<T> parse<T>(String key, T Function(Map<String, dynamic>) fromJson) {
      final raw = json[key];
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((e) => fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return InvoiceDetailsModel(
      invoiceId: (json['invoiceID'] as num?)?.toInt() ?? 0,
      invoiceNo: (json['invoiceNo'] as num?)?.toInt() ?? 0,
      invoiceDate: DateTime.tryParse(json['invoiceDate']?.toString() ?? ''),
      invoiceTypeId: (json['invoiceTypeID'] as num?)?.toInt(),
      customerName: json['customerName'] as String?,
      payingType: (json['payingType'] as num?)?.toInt() ?? 0,
      totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0,
      totalDiscount: (json['totalDiscount'] as num?)?.toDouble() ?? 0,
      totalAddition: (json['totalAddition'] as num?)?.toDouble() ?? 0,
      finalValue: (json['finalValue'] as num?)?.toDouble() ?? 0,
      createdBy: json['createdBy'] as String?,
      companyBranchId: (json['companyBranchID'] as num?)?.toInt(),
      companyBranchName: json['companyBranchName'] as String?,
      taxBill: json['taxBill'] == true,
      currencySymbol: json['currencySymbol'] as String?,
      items: parse('salesInvoiceItems', InvoiceDetailsItem.fromJson),
      payWays: parse('salesInvoicePayWays', InvoiceDetailsPayWay.fromJson),
      discounts: parse('salesInvoiceDiscounts', InvoiceDetailsDiscount.fromJson),
    );
  }

  @override
  List<Object?> get props => [invoiceId, invoiceNo];
}

class InvoiceDetailsItem extends Equatable {
  final String productArName;
  final String productEnName;
  final String? productCode;
  final String? barCode;
  final num quantity;
  final String? unitName;
  final double price;
  final double discount;
  final double totalValue;
  final String? storeName;

  const InvoiceDetailsItem({
    this.productArName = '',
    this.productEnName = '',
    this.productCode,
    this.barCode,
    this.quantity = 0,
    this.unitName,
    this.price = 0,
    this.discount = 0,
    this.totalValue = 0,
    this.storeName,
  });

  factory InvoiceDetailsItem.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailsItem(
      productArName: json['productArName'] ?? '',
      productEnName: json['productEnName'] ?? '',
      productCode: json['productCode'] as String?,
      barCode: json['barCode'] as String?,
      quantity: (json['quantity'] as num?) ?? 0,
      unitName: json['unitName'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0,
      storeName: json['storeName'] as String?,
    );
  }

  /// Localized product name, falling back to the other language.
  String displayName(bool isAr) {
    final primary = isAr ? productArName : productEnName;
    if (primary.trim().isNotEmpty) return primary;
    final fallback = isAr ? productEnName : productArName;
    return fallback.trim().isNotEmpty ? fallback : (productCode ?? '');
  }

  @override
  List<Object?> get props => [barCode, productCode, rowKey];

  String get rowKey => '$productCode-$barCode-$price';
}

class InvoiceDetailsPayWay extends Equatable {
  final int payingType;
  final double rate;
  final double localValue;
  final String? payWayName;
  final String? payWayEnName;

  const InvoiceDetailsPayWay({
    this.payingType = 0,
    this.rate = 1,
    this.localValue = 0,
    this.payWayName,
    this.payWayEnName,
  });

  factory InvoiceDetailsPayWay.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailsPayWay(
      payingType: (json['payingType'] as num?)?.toInt() ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 1,
      localValue: (json['localValue'] as num?)?.toDouble() ?? 0,
      payWayName: json['payWayName'] as String?,
      payWayEnName: json['payWayEnName'] as String?,
    );
  }

  @override
  List<Object?> get props => [payingType, localValue, rate];
}

class InvoiceDetailsDiscount extends Equatable {
  final String? accountArName;
  final String? accountEnName;
  final double discount;
  final double addation;
  final String? notes;

  const InvoiceDetailsDiscount({
    this.accountArName,
    this.accountEnName,
    this.discount = 0,
    this.addation = 0,
    this.notes,
  });

  factory InvoiceDetailsDiscount.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailsDiscount(
      accountArName: json['accountArName'] as String?,
      accountEnName: json['accountEnName'] as String?,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      addation: (json['addation'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [accountArName, discount, addation, notes];
}
