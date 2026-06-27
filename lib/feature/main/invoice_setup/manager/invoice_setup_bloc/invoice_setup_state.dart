part of '../../invoice_setup_imports.dart';

/// Branches were extracted into their own [BranchBloc] — this state now
/// owns only currencies + patterns + selection bookkeeping.
class InvoiceSetupState extends Equatable {
  final Status patternsStatus;
  final Status currenciesStatus;

  final List<InvoicePatternModel> patterns;
  final List<CurrencyModel>       currencies;

  final int    selectedPatternId;
  final int    selectedCurrencyId;
  final double selectedCurrencyRate;

  final String? errorMessage;

  const InvoiceSetupState({
    this.patternsStatus   = Status.initial,
    this.currenciesStatus = Status.initial,
    this.patterns         = const [],
    this.currencies       = const [],
    this.selectedPatternId  = -1,
    this.selectedCurrencyId = 0,
    this.selectedCurrencyRate = 1.0,
    this.errorMessage,
  });

  InvoicePatternModel? get selectedPattern =>
      patterns.where((p) => p.patternId == selectedPatternId).isNotEmpty
          ? patterns.firstWhere((p) => p.patternId == selectedPatternId)
          : null;

  CurrencyModel? get selectedCurrency =>
      currencies.where((c) => c.currencyId == selectedCurrencyId).isNotEmpty
          ? currencies.firstWhere((c) => c.currencyId == selectedCurrencyId)
          : null;

  bool get isReady => selectedPatternId != -1;

  InvoiceSetupState copyWith({
    Status? patternsStatus,
    Status? currenciesStatus,
    List<InvoicePatternModel>? patterns,
    List<CurrencyModel>?       currencies,
    int?    selectedPatternId,
    int?    selectedCurrencyId,
    double? selectedCurrencyRate,
    String? errorMessage,
  }) {
    return InvoiceSetupState(
      patternsStatus:       patternsStatus   ?? this.patternsStatus,
      currenciesStatus:     currenciesStatus ?? this.currenciesStatus,
      patterns:             patterns         ?? this.patterns,
      currencies:           currencies       ?? this.currencies,
      selectedPatternId:    selectedPatternId    ?? this.selectedPatternId,
      selectedCurrencyId:   selectedCurrencyId   ?? this.selectedCurrencyId,
      selectedCurrencyRate: selectedCurrencyRate ?? this.selectedCurrencyRate,
      errorMessage:         errorMessage         ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        patternsStatus, currenciesStatus,
        patterns, currencies,
        selectedPatternId,
        selectedCurrencyId, selectedCurrencyRate,
        errorMessage,
      ];
}
