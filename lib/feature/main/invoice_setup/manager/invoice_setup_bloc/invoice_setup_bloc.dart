part of '../../invoice_setup_imports.dart';

// ── State ─────────────────────────────────────────────────────────────────────
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

// ── Bloc ──────────────────────────────────────────────────────────────────────
class InvoiceSetupBloc
    extends Bloc<InvoiceSetupEvent, InvoiceSetupState> {
  final InvoiceSetupDataSource _dataSource;

  InvoiceSetupBloc({required InvoiceSetupDataSource dataSource})
      : _dataSource = dataSource,
        super(const InvoiceSetupState()) {
    on<LoadInvoiceSetupData>(_onLoadAll);
    on<LoadPatternsByBranch>(_onLoadPatterns);
    on<SelectBranch>(_onSelectBranch);
    on<SelectPattern>(_onSelectPattern);
    on<SelectCurrency>(_onSelectCurrency);
  }

  // ── Load all (branches + currencies in parallel, then patterns) ────────────
  Future<void> _onLoadAll(
      LoadInvoiceSetupData event,
      Emitter<InvoiceSetupState> emit,
      ) async {
    emit(state.copyWith(
      branchesStatus:   Status.loading,
      currenciesStatus: Status.loading,
    ));

    // ── Run separately to preserve generic types ──────────────────────────────
    final branchResult   = await _dataSource.getBranches();
    final currencyResult = await _dataSource.getCurrencies();

    // ── Handle branches ───────────────────────────────────────────────────────
    int autoSelectedBranchId = state.selectedBranchId;

    branchResult.fold(
          (failure) => emit(state.copyWith(
        branchesStatus: Status.failure,
        errorMessage:   failure.message,
      )),
          (branches) {
        autoSelectedBranchId =
        branches.isNotEmpty ? branches.first.branchId : 0;
        emit(state.copyWith(
          branchesStatus:   Status.success,
          branches:         branches,
          selectedBranchId: autoSelectedBranchId,
        ));
      },
    );

    // ── Handle currencies ─────────────────────────────────────────────────────
    currencyResult.fold(
          (failure) => emit(state.copyWith(
        currenciesStatus: Status.failure,
        errorMessage:     failure.message,
      )),
          (currencies) {
        final defaultCurrency =
        currencies.where((c) => c.isDefault).isNotEmpty
            ? currencies.firstWhere((c) => c.isDefault)
            : currencies.isNotEmpty
            ? currencies.first
            : null;
        emit(state.copyWith(
          currenciesStatus:     Status.success,
          currencies:           currencies,
          selectedCurrencyId:   defaultCurrency?.currencyId ?? 0,
          selectedCurrencyRate: defaultCurrency?.rate       ?? 1.0,
        ));
      },
    );

    // ── Load patterns for auto-selected branch ────────────────────────────────
    if (autoSelectedBranchId != 0) {
      add(LoadPatternsByBranch(
        branchId:     autoSelectedBranchId,
        isPriceQuote: event.isPriceQuote,
      ));
    }
  }

  // ── Load patterns for a branch ─────────────────────────────────────────────
  Future<void> _onLoadPatterns(
      LoadPatternsByBranch event,
      Emitter<InvoiceSetupState> emit,
      ) async {
    emit(state.copyWith(
      patternsStatus:  Status.loading,
      patterns:        [],
      selectedPatternId: -1,
    ));

    final result = event.isPriceQuote
        ? await _dataSource.getQuotePatterns(branchId: event.branchId)
        : await _dataSource.getInvoicePatterns(branchId: event.branchId);

    result.fold(
          (failure) => emit(state.copyWith(
        patternsStatus: Status.failure,
        errorMessage:   failure.message,
      )),
          (patterns) {
        // Auto-select first pattern
        final autoPatternId =
        patterns.isNotEmpty ? patterns.first.patternId : -1;
        emit(state.copyWith(
          patternsStatus:   Status.success,
          patterns:         patterns,
          selectedPatternId: autoPatternId,
        ));
      },
    );
  }

  // ── Select branch → reload patterns ───────────────────────────────────────
  Future<void> _onSelectBranch(
      SelectBranch event,
      Emitter<InvoiceSetupState> emit,
      ) async {
    emit(state.copyWith(selectedBranchId: event.branchId));
    add(LoadPatternsByBranch(
      branchId:     event.branchId,
      isPriceQuote: event.isPriceQuote,
    ));
  }

  // ── Select pattern ─────────────────────────────────────────────────────────
  void _onSelectPattern(
      SelectPattern event,
      Emitter<InvoiceSetupState> emit,
      ) {
    emit(state.copyWith(selectedPatternId: event.patternId));
  }

  // ── Select currency ────────────────────────────────────────────────────────
  void _onSelectCurrency(
      SelectCurrency event,
      Emitter<InvoiceSetupState> emit,
      ) {
    emit(state.copyWith(
      selectedCurrencyId:   event.currencyId,
      selectedCurrencyRate: event.rate,
    ));
  }
}