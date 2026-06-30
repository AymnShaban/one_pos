part of '../../invoice_setup_imports.dart';

/// Currencies + patterns + selection. Branches live in [BranchBloc] now —
/// callers pass the active branchId in (typically from
/// `context.read<BranchBloc>().selectedId`) when loading patterns.
class InvoiceSetupBloc extends Bloc<InvoiceSetupEvent, InvoiceSetupState> {
  final InvoiceSetupDataSource _dataSource;

  InvoiceSetupBloc({required InvoiceSetupDataSource dataSource})
      : _dataSource = dataSource,
        super(const InvoiceSetupState()) {
    on<LoadInvoiceSetupData>(_onLoadAll);
    on<LoadPatternsByBranch>(_onLoadPatterns);
    on<SelectPattern>(_onSelectPattern);
    on<SelectCurrency>(_onSelectCurrency);
  }

  /// Load currencies. If a real `branchId` is supplied, also fire a
  /// patterns load — but callers that don't yet know the branch can pass
  /// `branchId: 0` and dispatch [LoadPatternsByBranch] later (e.g. after
  /// listening to [BranchBloc] for the auto-selection).
  Future<void> _onLoadAll(
    LoadInvoiceSetupData event,
    Emitter<InvoiceSetupState> emit,
  ) async {
    emit(state.copyWith(currenciesStatus: Status.loading));

    final currencyResult = await _dataSource.getCurrencies();
    currencyResult.fold(
      (failure) => emit(state.copyWith(
        currenciesStatus: Status.failure,
        errorMessage: failure.message,
      )),
      (currencies) {
        final defaultCurrency = currencies.where((c) => c.isDefault).isNotEmpty
            ? currencies.firstWhere((c) => c.isDefault)
            : currencies.isNotEmpty
                ? currencies.first
                : null;
        emit(state.copyWith(
          currenciesStatus: Status.success,
          currencies: currencies,
          selectedCurrencyId: defaultCurrency?.currencyId ?? 0,
          selectedCurrencyRate: defaultCurrency?.rate ?? 1.0,
        ));
      },
    );

    if (event.branchId != 0) {
      add(LoadPatternsByBranch(
        branchId: event.branchId,
        isPriceQuote: event.isPriceQuote,
      ));
    }
  }

  Future<void> _onLoadPatterns(
    LoadPatternsByBranch event,
    Emitter<InvoiceSetupState> emit,
  ) async {
    emit(state.copyWith(
      patternsStatus: Status.loading,
      patterns: [],
      selectedPatternId: -1,
    ));

    final result = await _dataSource.getPatternsByBranch(event.branchId);
    result.fold(
      (failure) => emit(state.copyWith(
        patternsStatus: Status.failure,
        errorMessage: failure.message,
      )),
      (all) {
        // Server already scoped to this branch — only filter by mode
        // (quotes/orders vs. real invoices) here.
        final patterns = all.where((p) {
          return event.isPriceQuote ? p.isPriceQuote : !p.isPriceQuote;
        }).toList();

        final autoPatternId =
            patterns.isNotEmpty ? patterns.first.patternId : -1;
        emit(state.copyWith(
          patternsStatus: Status.success,
          patterns: patterns,
          selectedPatternId: autoPatternId,
        ));
      },
    );
  }

  void _onSelectPattern(
    SelectPattern event,
    Emitter<InvoiceSetupState> emit,
  ) {
    emit(state.copyWith(selectedPatternId: event.patternId));
  }

  void _onSelectCurrency(
    SelectCurrency event,
    Emitter<InvoiceSetupState> emit,
  ) {
    emit(state.copyWith(
      selectedCurrencyId: event.currencyId,
      selectedCurrencyRate: event.rate,
    ));
  }
}
