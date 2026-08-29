import 'package:equatable/equatable.dart';

class BillRevenueRequestModel extends Equatable {
  final String startDate;
  final String endDate;
  final int mode;
  final int groupBy;
  final int orderBy;
  final int? currencyID;
  final double exchangeRate;
  final int? custId;
  final int? parentAcId;
  final int? empId;
  final int? costCenterId;
  final int? branchId;
  final int? storeId;
  final List<int> bsrCodes;
  final List<String> payTypes;
  final String? userName;
  final bool showZeroBillsOnly;
  final bool filterByDiscount;
  final double? minDiscountPercentage;
  final bool costFromLastBuy;
  final bool showDisc;
  final bool showFreeCost;
  final bool showFreeType;
  final bool showPrepaid;
  final bool showRemainder;
  final bool showTotalSalesmen;
  final bool showCustomerBranch;
  final bool showClientBranch;
  final bool showTotalWeight;
  final String language;

  const BillRevenueRequestModel({
    required this.startDate,
    required this.endDate,
    required this.mode,
    required this.groupBy,
    required this.orderBy,
    this.currencyID,
    this.exchangeRate = 1.0,
    this.custId,
    this.parentAcId,
    this.empId,
    this.costCenterId,
    this.branchId,
    this.storeId,
    this.bsrCodes = const [],
    this.payTypes = const [],
    this.userName,
    this.showZeroBillsOnly = false,
    this.filterByDiscount = false,
    this.minDiscountPercentage,
    this.costFromLastBuy = false,
    this.showDisc = true,
    this.showFreeCost = false,
    this.showFreeType = false,
    this.showPrepaid = false,
    this.showRemainder = false,
    this.showTotalSalesmen = false,
    this.showCustomerBranch = false,
    this.showClientBranch = false,
    this.showTotalWeight = false,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      "startDate": startDate,
      "endDate": endDate,
      "mode": mode,
      "groupBy": groupBy,
      "orderBy": orderBy,
      "currencyID": currencyID,
      "exchangeRate": exchangeRate,
      "custId": custId,
      "parentAcId": parentAcId,
      "empId": empId,
      "costCenterId": costCenterId,
      "branchId": branchId,
      "storeId": storeId,
      "bsrCodes": bsrCodes,
      "payTypes": payTypes,
      "userName": userName,
      "showZeroBillsOnly": showZeroBillsOnly,
      "filterByDiscount": filterByDiscount,
      "minDiscountPercentage": minDiscountPercentage,
      "costFromLastBuy": costFromLastBuy,
      "showDisc": showDisc,
      "showFreeCost": showFreeCost,
      "showFreeType": showFreeType,
      "showPrepaid": showPrepaid,
      "showRemainder": showRemainder,
      "showTotalSalesmen": showTotalSalesmen,
      "showCustomerBranch": showCustomerBranch,
      "showClientBranch": showClientBranch,
      "showTotalWeight": showTotalWeight,
      "language": language,
    };
  }

  @override
  List<Object?> get props => [
    startDate, endDate, mode, groupBy, orderBy, currencyID, exchangeRate,
    custId, parentAcId, empId, costCenterId, branchId, storeId, bsrCodes,
    payTypes, userName, showZeroBillsOnly, filterByDiscount, minDiscountPercentage,
    costFromLastBuy, showDisc, showFreeCost, showFreeType, showPrepaid,
    showRemainder, showTotalSalesmen, showCustomerBranch, showClientBranch,
    showTotalWeight, language,
  ];
}