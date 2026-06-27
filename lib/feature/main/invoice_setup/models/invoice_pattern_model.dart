part of '../invoice_setup_imports.dart';

/// Stock-effect category — mirrors `dbo.BillTypes.ID`. This tells you what
/// the pattern does to inventory, NOT which business operation it is. For
/// the operation itself, look at [SupposeType] / `supposeType`.
///
///   1 = inputs    (إدخالات)  — stock comes IN (buy, sales-return, receive,
///                              opening, adjust-input)
///   2 = outputs   (إخراجات)  — stock goes OUT (sell, purchase-return, issue,
///                              adjust-output)
///   3 = transfer  (تحويلات)  — between stores (store-transfer, adjust ops,
///                              price-adjust)
///   4 = noEffect  (لا تؤثر)  — non-posting (quotes, orders)
enum PatternCategory {
  inputs,
  outputs,
  transfer,
  noEffect,
  unknown;

  static PatternCategory fromCode(int code) {
    switch (code) {
      case 1:
        return PatternCategory.inputs;
      case 2:
        return PatternCategory.outputs;
      case 3:
        return PatternCategory.transfer;
      case 4:
        return PatternCategory.noEffect;
      default:
        return PatternCategory.unknown;
    }
  }
}

/// Specific business operation — mirrors `dbo.BillSupposedType.ID`. This is
/// what each feature filters on when picking patterns to show the user
/// (e.g. Sales screen → `supposeType == sells`, Quotes → `priceQuote`).
enum SupposeType {
  boughts(1),
  sells(2),
  backSells(3),
  backBoughts(4),
  sentEntries(5),
  receivedEntries(6),
  orders(7),
  priceQuote(8),
  storeTransfer(9),
  storeTransferLite(10),
  openingStock(11),
  billAdjustOperation(12),
  billAdjustInput(13),
  billAdjustOutput(14),
  billAdjustPrices(15),
  unknown(0);

  final int code;
  const SupposeType(this.code);

  static SupposeType fromCode(int code) =>
      SupposeType.values.firstWhere((s) => s.code == code,
          orElse: () => SupposeType.unknown);
}

/// Maps `GET /api/InvoiceSetting/GetAllTypes`. One pattern row carries the
/// full set of defaults needed to bootstrap an invoice of that pattern:
/// branch, store, currency, the material/extra GL accounts, and which
/// category (purchases / sales / transfers / quotes-orders) it belongs to.
///
/// The legacy getters (`patternArName`, `patternEnName`, `isPriceQuote`)
/// are kept so existing call sites in basket / new_invoice / invoice_setup
/// compile unchanged.
class InvoicePatternModel extends Equatable {
  // ── Identity ─────────────────────────────────────────────────────────
  final int patternId;
  final String patternName;
  final String patternEnglishName;
  final int patternType;
  final int supposeType;

  // ── GL accounts ──────────────────────────────────────────────────────
  final int? materialAccountId;
  final String? materialAccountCode;
  final String? materialAccountName;
  final String? materialAccountEnglishName;
  final int? extraAccountId;
  final String? extraAccountCode;
  final String? extraAccountName;
  final String? extraAccountEnglishName;

  // ── Cost center (nullable across patterns) ───────────────────────────
  final int? costCenterId;
  final String? costCenterCode;
  final String? costCenterName;
  final String? costCenterEnglishName;

  // ── Branch / store / currency defaults ───────────────────────────────
  final int? branchId;
  final String? branchCode;
  final String? branchName;
  final String? branchEnglishName;
  final int? storeId;
  final int? storeCode;
  final String? storeName;
  final String? storeEnglishName;
  final int currencyId;
  final String? currencyName;
  final String? currencyEnglishName;

  // ── Payment-flow flags ───────────────────────────────────────────────
  final bool cashOnly;
  final int payWayId;
  final bool payByAccount;

  const InvoicePatternModel({
    required this.patternId,
    required this.patternName,
    required this.patternEnglishName,
    this.patternType = 0,
    this.supposeType = 0,
    this.materialAccountId,
    this.materialAccountCode,
    this.materialAccountName,
    this.materialAccountEnglishName,
    this.extraAccountId,
    this.extraAccountCode,
    this.extraAccountName,
    this.extraAccountEnglishName,
    this.costCenterId,
    this.costCenterCode,
    this.costCenterName,
    this.costCenterEnglishName,
    this.branchId,
    this.branchCode,
    this.branchName,
    this.branchEnglishName,
    this.storeId,
    this.storeCode,
    this.storeName,
    this.storeEnglishName,
    this.currencyId = -1,
    this.currencyName,
    this.currencyEnglishName,
    this.cashOnly = false,
    this.payWayId = 0,
    this.payByAccount = false,
  });

  factory InvoicePatternModel.fromJson(Map<String, dynamic> json) {
    int? i(dynamic v) => (v as num?)?.toInt();
    String? s(dynamic v) => v as String?;

    return InvoicePatternModel(
      patternId: i(json['patternID']) ?? i(json['PatternID']) ?? 0,
      patternName: s(json['patternName']) ?? s(json['PatternName']) ?? '',
      patternEnglishName: s(json['patternEnglishName']) ??
          s(json['PatternEnglishName']) ??
          s(json['patternName']) ??
          '',
      patternType: i(json['patternType']) ?? 0,
      supposeType: i(json['supposeType']) ?? 0,
      materialAccountId: i(json['materialAcountID']),
      materialAccountCode: s(json['materialAcountCode']),
      materialAccountName: s(json['materialAcountName']),
      materialAccountEnglishName: s(json['materialAcountEnglishName']),
      extraAccountId: i(json['extraAcountID']),
      extraAccountCode: s(json['extraAcountCode']),
      extraAccountName: s(json['extraAcountName']),
      extraAccountEnglishName: s(json['extraAcountEnglishName']),
      costCenterId: i(json['costCenterID']),
      costCenterCode: s(json['costCenterCode']),
      costCenterName: s(json['costCenterName']),
      costCenterEnglishName: s(json['costCenterEnglishName']),
      branchId: i(json['branchID']),
      branchCode: s(json['branchCode']),
      branchName: s(json['branchName']),
      branchEnglishName: s(json['branchEName']),
      storeId: i(json['storeID']),
      storeCode: i(json['storeCode']),
      storeName: s(json['storeName']),
      storeEnglishName: s(json['storeEnglishName']),
      currencyId: i(json['currencyID']) ?? -1,
      currencyName: s(json['currencyName']),
      currencyEnglishName: s(json['currencyEName']),
      cashOnly: json['cashOnly'] == true,
      payWayId: i(json['payWayID']) ?? 0,
      payByAccount: json['payByAccount'] == true,
    );
  }

  // ── Derived helpers ──────────────────────────────────────────────────
  /// Stock-effect bucket (BillTypes.ID).
  PatternCategory get category => PatternCategory.fromCode(patternType);

  /// Specific operation (BillSupposedType.ID). This is what feature screens
  /// filter on — e.g. Sales tab uses `supposeType == SupposeType.sells`.
  SupposeType get suppose => SupposeType.fromCode(supposeType);

  // Back-compat: callers (basket, invoice_setup) still read these names.
  String get patternArName => patternName;
  String get patternEnName => patternEnglishName;

  // Quick predicates for the most common filters across the app.
  bool get isSale => suppose == SupposeType.sells;
  bool get isPurchase => suppose == SupposeType.boughts;
  bool get isSalesReturn => suppose == SupposeType.backSells;
  bool get isPurchaseReturn => suppose == SupposeType.backBoughts;
  bool get isOrder => suppose == SupposeType.orders;
  bool get isPriceQuote => suppose == SupposeType.priceQuote;
  bool get isStoreTransfer =>
      suppose == SupposeType.storeTransfer ||
      suppose == SupposeType.storeTransferLite;

  Map<String, dynamic> toJson() => {
        'patternID': patternId,
        'patternName': patternName,
        'patternEnglishName': patternEnglishName,
        'patternType': patternType,
        'supposeType': supposeType,
        'materialAcountID': materialAccountId,
        'materialAcountCode': materialAccountCode,
        'materialAcountName': materialAccountName,
        'materialAcountEnglishName': materialAccountEnglishName,
        'extraAcountID': extraAccountId,
        'extraAcountCode': extraAccountCode,
        'extraAcountName': extraAccountName,
        'extraAcountEnglishName': extraAccountEnglishName,
        'costCenterID': costCenterId,
        'costCenterCode': costCenterCode,
        'costCenterName': costCenterName,
        'costCenterEnglishName': costCenterEnglishName,
        'branchID': branchId,
        'branchCode': branchCode,
        'branchName': branchName,
        'branchEName': branchEnglishName,
        'storeID': storeId,
        'storeCode': storeCode,
        'storeName': storeName,
        'storeEnglishName': storeEnglishName,
        'currencyID': currencyId,
        'currencyName': currencyName,
        'currencyEName': currencyEnglishName,
        'cashOnly': cashOnly,
        'payWayID': payWayId,
        'payByAccount': payByAccount,
      };

  @override
  List<Object?> get props => [patternId, patternType];
}
