
import '../../../shared_imports.dart';
class CurrenciesBloc extends Bloc<CurrenciesEvent, CurrenciesState> {
  final CurrenciesDataSource dataSource;

  CurrenciesBloc({required this.dataSource}) : super(const CurrenciesState()) {
    on<LoadCurrencies>(_onLoadCurrencies);
    on<SelectCurrency>(_onSelectCurrency);
  }

  Future<void> _onLoadCurrencies(
      LoadCurrencies event,
      Emitter<CurrenciesState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getCurrencies();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (currencies) {
        int? selectedId;
        double? selectedRate;

        if (currencies.isNotEmpty) {
          // ✅ العملة الافتراضية (اللي rate = 1) أو أول عملة
          final defaultCurrency = currencies.firstWhere(
                (c) => c.rate == 1.0,
            orElse: () => currencies.first,
          );
          selectedId = defaultCurrency.currencyID;
          selectedRate = defaultCurrency.rate;
        }

        final allIds = currencies.map((c) => c.currencyID).toSet();

        emit(
          state.copyWith(
            status: Status.success,
            currencies: currencies,
            selectedCurrencyId: selectedId,
            selectedCurrencyIds: allIds,
            selectedExchangeRate: selectedRate, // ✅ سعر الصرف الافتراضي
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectCurrency(
      SelectCurrency event,
      Emitter<CurrenciesState> emit,
      ) {
    final currencyId = event.currencyId;

    // ✅ نتأكد إن العملة موجودة
    final exists = state.currencies.any((c) => c.currencyID == currencyId);

    if (exists) {
      // ✅ جيب سعر الصرف بتاع العملة المختارة
      final selectedCurrency = state.currencies.firstWhere(
            (c) => c.currencyID == currencyId,
      );

      emit(
        state.copyWith(
          selectedCurrencyId: currencyId,
          selectedCurrencyIds: {currencyId},
          selectedExchangeRate: selectedCurrency.rate, // ✅ سعر الصرف
        ),
      );
    }
  }
}