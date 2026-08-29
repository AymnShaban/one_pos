import '../../branch_profit_import.dart';

class BranchProfitRequestModel extends Equatable {
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime? dailyFrom;
  final DateTime? dailyTo;

  final List<int> branchIDs;
  final bool byAccount;
  final bool showExpenses;
  final bool analysis;
  final bool postedOnly;
  final bool profitFromLastPrice;
  final bool orderByBranch;
  final bool groupByBranch;

  const BranchProfitRequestModel({
    required this.fromDate,
    required this.toDate,
    required this.branchIDs,
    this.dailyFrom,
    this.dailyTo,
    this.byAccount = true,
    this.showExpenses = true,
    this.analysis = true,
    this.postedOnly = true,
    this.profitFromLastPrice = true,
    this.orderByBranch = true,
    this.groupByBranch = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'dailyFrom': dailyFrom?.toIso8601String(),
      'dailyTo': dailyTo?.toIso8601String(),
      'branchIDs': branchIDs,
      'byAccount': byAccount,
      'showExpenses': showExpenses,
      'analysis': analysis,
      'postedOnly': postedOnly,
      'profitFromLastPrice': profitFromLastPrice,
      'orderByBranch': orderByBranch,
      'groupByBranch': groupByBranch,
    };
  }

  factory BranchProfitRequestModel.create({
    required DateTime fromDate,
    required DateTime toDate,
    required List<int> branchIDs,
    DateTime? dailyFrom,
    DateTime? dailyTo,
    bool byAccount = true,
    bool showExpenses = true,
    bool analysis = true,
    bool postedOnly = true,
    bool profitFromLastPrice = true,
    bool orderByBranch = true,
    bool groupByBranch = true,
  }) {
    return BranchProfitRequestModel(
      fromDate: fromDate,
      toDate: toDate,
      dailyFrom: dailyFrom,
      dailyTo: dailyTo,
      branchIDs: branchIDs,
      byAccount: byAccount,
      showExpenses: showExpenses,
      analysis: analysis,
      postedOnly: postedOnly,
      profitFromLastPrice: profitFromLastPrice,
      orderByBranch: orderByBranch,
      groupByBranch: groupByBranch,
    );
  }

  @override
  List<Object?> get props => [
    fromDate,
    toDate,
    dailyFrom,
    dailyTo,
    branchIDs,
    byAccount,
    showExpenses,
    analysis,
    postedOnly,
    profitFromLastPrice,
    orderByBranch,
    groupByBranch,
  ];
}