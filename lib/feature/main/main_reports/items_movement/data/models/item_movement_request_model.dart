
class ItemMovementRequestModel {
  final String startDate;
  final String endDate;
  final bool showQtyPrevBalance;
  final bool isGroup;
  final List<String> materialIds;
  final int branchId;
  final List<int> sources;
  final List<String> sourceNames;
  final bool zeroValueOnly;
  final int unit;
  final int currencyIndex;
  final bool isMaterialMotionAnalysis;
  final bool isPriceRelatedTotalWeight;
  final bool isCustomerMaterialMotion;
  final bool multiDb;
  final List<String> dbNames;
  final bool showSerials;
  final bool expireDate;
  final bool explanationItem;
  final bool maxPurchaseFromAdditions;
  final bool arabic;
  final String materialId;
  final String groupId;
  final String storeId;
  final String costCenterId;
  final String category;
  final String contains;
  final String notContains;

  ItemMovementRequestModel({
    required this.startDate,
    required this.endDate,
    this.showQtyPrevBalance = true,
    this.isGroup = true,
    this.materialIds = const [],
    this.branchId = 0,
    this.sources = const [],
    this.sourceNames = const [],
    this.zeroValueOnly = true,
    this.unit = 0,
    this.currencyIndex = 0,
    this.isMaterialMotionAnalysis = true,
    this.isPriceRelatedTotalWeight = true,
    this.isCustomerMaterialMotion = true,
    this.multiDb = true,
    this.dbNames = const [],
    this.showSerials = true,
    this.expireDate = true,
    this.explanationItem = true,
    this.maxPurchaseFromAdditions = true,
    this.arabic = true,
    this.materialId = '',
    this.groupId = '',
    this.storeId = '',
    this.costCenterId = '',
    this.category = '',
    this.contains = '',
    this.notContains = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'showQtyPrevBalance': showQtyPrevBalance,
      'isGroup': isGroup,
      'materialIds': materialIds,
      'branchId': branchId,
      'sources': sources,
      'sourceNames': sourceNames,
      'zeroValueOnly': zeroValueOnly,
      'unit': unit,
      'currencyIndex': currencyIndex,
      'isMaterialMotionAnalysis': isMaterialMotionAnalysis,
      'isPriceRelatedTotalWeight': isPriceRelatedTotalWeight,
      'isCustomerMaterialMotion': isCustomerMaterialMotion,
      'multiDb': multiDb,
      'dbNames': dbNames,
      'showSerials': showSerials,
      'expireDate': expireDate,
      'explanationItem': explanationItem,
      'maxPurchaseFromAdditions': maxPurchaseFromAdditions,
      'arabic': arabic,
      'materialId': materialId,
      'groupId': groupId,
      'storeId': storeId,
      'costCenterId': costCenterId,
      'category': category,
      'contains': contains,
      'notContains': notContains,
    };
  }

  factory ItemMovementRequestModel.create({
    required DateTime fromDate,
    required DateTime toDate,
    String? materialId,
    String? groupId,
    String? storeId,
    String? costCenterId,
    int? branchId,
    List<int>? sources,
    int? unit,
    int? currencyIndex,
    bool? isGroup,
    bool? zeroValueOnly,
    bool? showQtyPrevBalance,
    bool? isMaterialMotionAnalysis,
    bool? isPriceRelatedTotalWeight,
    bool? isCustomerMaterialMotion,
    bool? showSerials,
    bool? expireDate,
    bool? explanationItem,
    bool? maxPurchaseFromAdditions,
    bool? arabic,
    String? category,
    String? contains,
    String? notContains,
  }) {
    return ItemMovementRequestModel(
      startDate: fromDate.toIso8601String(),
      endDate: toDate.toIso8601String(),
      materialId: materialId ?? '',
      groupId: groupId ?? '',
      storeId: storeId ?? '',
      costCenterId: costCenterId ?? '',
      branchId: branchId ?? 0,
      sources: sources ?? [],
      unit: unit ?? 0,
      currencyIndex: currencyIndex ?? 0,
      isGroup: isGroup ?? true,
      zeroValueOnly: zeroValueOnly ?? true,
      showQtyPrevBalance: showQtyPrevBalance ?? true,
      isMaterialMotionAnalysis: isMaterialMotionAnalysis ?? true,
      isPriceRelatedTotalWeight: isPriceRelatedTotalWeight ?? true,
      isCustomerMaterialMotion: isCustomerMaterialMotion ?? true,
      showSerials: showSerials ?? true,
      expireDate: expireDate ?? true,
      explanationItem: explanationItem ?? true,
      maxPurchaseFromAdditions: maxPurchaseFromAdditions ?? true,
      arabic: arabic ?? true,
      category: category ?? '',
      contains: contains ?? '',
      notContains: notContains ?? '',
    );
  }
}