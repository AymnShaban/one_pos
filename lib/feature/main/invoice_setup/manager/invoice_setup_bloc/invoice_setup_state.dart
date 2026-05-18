part of '../../invoice_setup_imports.dart';


class InvoiceSetupState extends Equatable {
  final Status branchesStatus;
  final Status patternsStatus;
  final Status currenciesStatus;

  final List<BranchModel>         branches;
  final List<InvoicePatternModel> patterns;
  final List<CurrencyModel>       currencies;

  final int    selectedBranchId;
  final int    selectedPatternId;
  final int    selectedCurrencyId;
  final double selectedCurrencyRate;

  final String? errorMessage;

  const InvoiceSetupState({
    this.branchesStatus   = Status.initial,
    this.patternsStatus   = Status.initial,
    this.currenciesStatus = Status.initial,
    this.branches         = const [],
    this.patterns         = const [],
    this.currencies       = const [],
    this.selectedBranchId   = 0,
    this.selectedPatternId  = -1,
    this.selectedCurrencyId = 0,
    this.selectedCurrencyRate = 1.0,
    this.errorMessage,
  });

  // Derived getters
  BranchModel? get selectedBranch =>
      branches.where((b) => b.branchId == selectedBranchId).isNotEmpty
          ? branches.firstWhere((b) => b.branchId == selectedBranchId)
          : null;

  InvoicePatternModel? get selectedPattern =>
      patterns.where((p) => p.patternId == selectedPatternId).isNotEmpty
          ? patterns.firstWhere((p) => p.patternId == selectedPatternId)
          : null;

  CurrencyModel? get selectedCurrency =>
      currencies.where((c) => c.currencyId == selectedCurrencyId).isNotEmpty
          ? currencies.firstWhere((c) => c.currencyId == selectedCurrencyId)
          : null;

  bool get isReady =>
      selectedBranchId != 0 && selectedPatternId != -1;

  InvoiceSetupState copyWith({
    Status? branchesStatus,
    Status? patternsStatus,
    Status? currenciesStatus,
    List<BranchModel>?         branches,
    List<InvoicePatternModel>? patterns,
    List<CurrencyModel>?       currencies,
    int?    selectedBranchId,
    int?    selectedPatternId,
    int?    selectedCurrencyId,
    double? selectedCurrencyRate,
    String? errorMessage,
  }) {
    return InvoiceSetupState(
      branchesStatus:       branchesStatus   ?? this.branchesStatus,
      patternsStatus:       patternsStatus   ?? this.patternsStatus,
      currenciesStatus:     currenciesStatus ?? this.currenciesStatus,
      branches:             branches         ?? this.branches,
      patterns:             patterns         ?? this.patterns,
      currencies:           currencies       ?? this.currencies,
      selectedBranchId:     selectedBranchId     ?? this.selectedBranchId,
      selectedPatternId:    selectedPatternId    ?? this.selectedPatternId,
      selectedCurrencyId:   selectedCurrencyId   ?? this.selectedCurrencyId,
      selectedCurrencyRate: selectedCurrencyRate ?? this.selectedCurrencyRate,
      errorMessage:         errorMessage         ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    branchesStatus, patternsStatus, currenciesStatus,
    branches, patterns, currencies,
    selectedBranchId, selectedPatternId,
    selectedCurrencyId, selectedCurrencyRate,
    errorMessage,
  ];
}
