import '../../item_profit_import.dart';
class ItemProfitRequestModel extends Equatable {
  final String startDate;
  final String endDate;
  final List<int> branchIds;
  final List<int> payTypes;
  final List<int> bsrCodes;
  final int priceTypeIndex;
  final int costTypeIndex;
  final bool showReturn;
  final bool showWithoutCustomer;
  final bool showCustomerBranch;
  final bool filterCostZero;
  final bool filterCostEqSale;
  final bool filterCostBigSale;
  final String language;

  const ItemProfitRequestModel({
    required this.startDate,
    required this.endDate,
    required this.branchIds,
    required this.payTypes,
    required this.bsrCodes,
    required this.priceTypeIndex,
    required this.costTypeIndex,
    required this.showReturn,
    required this.showWithoutCustomer,
    required this.showCustomerBranch,
    required this.filterCostZero,
    required this.filterCostEqSale,
    required this.filterCostBigSale,
    required this.language,
  });

  factory ItemProfitRequestModel.fromJson(Map<String, dynamic> json) {
    return ItemProfitRequestModel(
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      branchIds: List<int>.from(json['branchIds'] ?? []),
      payTypes: List<int>.from(json['payTypes'] ?? []),
      bsrCodes: List<int>.from(json['bsrCodes'] ?? []),
      priceTypeIndex: json['priceTypeIndex'] ?? 0,
      costTypeIndex: json['costTypeIndex'] ?? 0,
      showReturn: json['showReturn'] ?? false,
      showWithoutCustomer: json['showWithoutCustomer'] ?? false,
      showCustomerBranch: json['showCustomerBranch'] ?? false,
      filterCostZero: json['filterCostZero'] ?? false,
      filterCostEqSale: json['filterCostEqSale'] ?? false,
      filterCostBigSale: json['filterCostBigSale'] ?? false,
      language: json['language'] ?? 'ar',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'branchIds': branchIds,
      'payTypes': payTypes,
      'bsrCodes': bsrCodes,
      'priceTypeIndex': priceTypeIndex,
      'costTypeIndex': costTypeIndex,
      'showReturn': showReturn,
      'showWithoutCustomer': showWithoutCustomer,
      'showCustomerBranch': showCustomerBranch,
      'filterCostZero': filterCostZero,
      'filterCostEqSale': filterCostEqSale,
      'filterCostBigSale': filterCostBigSale,
      'language': language,
    };
  }

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    branchIds,
    payTypes,
    bsrCodes,
    priceTypeIndex,
    costTypeIndex,
    showReturn,
    showWithoutCustomer,
    showCustomerBranch,
    filterCostZero,
    filterCostEqSale,
    filterCostBigSale,
    language,
  ];
}