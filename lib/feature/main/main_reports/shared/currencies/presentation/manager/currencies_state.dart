import '../../../shared_imports.dart';
class CurrenciesState extends Equatable {
  final Status status;
  final List<CurrencyModel> currencies;
  final Set<int> selectedCurrencyIds;
  final int? selectedCurrencyId;
  final double? selectedExchangeRate;
  final String? errorMessage;

  const CurrenciesState({
    this.status = Status.initial,
    this.currencies = const [],
    this.selectedCurrencyIds = const {},
    this.selectedCurrencyId,
    this.selectedExchangeRate,
    this.errorMessage,
  });

  bool get hasCurrencies => currencies.isNotEmpty;

  CurrencyModel? get selectedCurrency {
    if (selectedCurrencyId == null) return null;
    try {
      return currencies.firstWhere(
            (currency) => currency.currencyID == selectedCurrencyId,
      );
    } catch (e) {
      return null;
    }
  }

  CurrenciesState copyWith({
    Status? status,
    List<CurrencyModel>? currencies,
    Set<int>? selectedCurrencyIds,
    int? selectedCurrencyId,
    double? selectedExchangeRate,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return CurrenciesState(
      status: status ?? this.status,
      currencies: currencies ?? this.currencies,
      selectedCurrencyIds: selectedCurrencyIds ?? this.selectedCurrencyIds,
      selectedCurrencyId: clearSelected
          ? null
          : (selectedCurrencyId ?? this.selectedCurrencyId),
      selectedExchangeRate: clearSelected
          ? null
          : (selectedExchangeRate ?? this.selectedExchangeRate),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currencies,
    selectedCurrencyIds,
    selectedCurrencyId,
    selectedExchangeRate,
    errorMessage,
  ];
}
