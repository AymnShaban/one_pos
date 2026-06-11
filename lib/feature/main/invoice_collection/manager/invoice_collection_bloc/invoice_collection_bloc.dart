part of '../../invoice_collection_imports.dart';

class InvoiceCollectionBloc
    extends Bloc<InvoiceCollectionEvent, InvoiceCollectionState> {
  final InvoiceCollectionDataSource _dataSource;

  InvoiceCollectionBloc({required InvoiceCollectionDataSource dataSource})
      : _dataSource = dataSource,
        super(const InvoiceCollectionState()) {
    on<LoadCollectionSetupData>(_onLoadSetup);
    on<CollectionBranchChanged>(_onBranchChanged);
    on<CollectionCurrencyChanged>(_onCurrencyChanged);
    on<CollectionPayWayChanged>(_onPayWayChanged);
    on<CollectionBondTypeChanged>(_onBondTypeChanged);
    on<CollectionInvoiceLinked>(_onInvoiceLinked);
    on<CollectionCustomerSearched>(_onCustomerSearched);
    on<SubmitCollection>(_onSubmit);
    on<EditCollection>(_onEdit);
  }

  // ── Load all setup data ────────────────────────────────────────────────
  Future<void> _onLoadSetup(
    LoadCollectionSetupData event,
    Emitter<InvoiceCollectionState> emit,
  ) async {
    emit(state.copyWith(
      branchesStatus: Status.loading,
      currenciesStatus: Status.loading,
      payWaysStatus: Status.loading,
      bondTypesStatus: Status.loading,
    ));

    // ── Branches ──────────────────────────────────────────────────────
    final branchesResult = await _dataSource.getBranches();
    int firstBranchId = 0;
    branchesResult.fold(
      (failure) => emit(state.copyWith(
        branchesStatus: Status.failure,
        errorMessage: failure.message,
      )),
      (branches) {
        firstBranchId = branches.isNotEmpty ? (branches.first['ID'] ?? 0) : 0;
        emit(state.copyWith(
          branchesStatus: Status.success,
          branches: branches,
          selectedBranchId: firstBranchId,
        ));
      },
    );
    if (firstBranchId != 0) {
      await _loadBondTypes(firstBranchId, emit);
    }

    // ── Currencies ────────────────────────────────────────────────────
    final currenciesResult = await _dataSource.getCurrencies();
    currenciesResult.fold(
      (failure) => emit(state.copyWith(
        currenciesStatus: Status.failure,
        errorMessage: failure.message,
      )),
      (currencies) {
        final defaultCurrency =
            currencies.isNotEmpty ? currencies.first : null;
        emit(state.copyWith(
          currenciesStatus: Status.success,
          currencies: currencies,
          selectedCurrencyId: defaultCurrency?['CurrencyID'] ?? 0,
          selectedCurrencyRate:
              (defaultCurrency?['Rate'] ?? 1.0).toDouble(),
        ));
      },
    );

    // ── Pay ways ──────────────────────────────────────────────────────
    final payWaysResult = await _dataSource.getPayWays();
    payWaysResult.fold(
      (failure) => emit(state.copyWith(
        payWaysStatus: Status.failure,
        errorMessage: failure.message,
      )),
      (payWays) => emit(state.copyWith(
        payWaysStatus: Status.success,
        payWays: payWays,
        selectedCodePw: payWays.isNotEmpty
            ? (payWays.first['Code_PW'] as num).toInt()
            : 0,
      )),
    );
  }

  Future<void> _loadBondTypes(
    int branchId,
    Emitter<InvoiceCollectionState> emit,
  ) async {
    final result = await _dataSource.getBondTypesByBranch(branchId);
    await result.fold(
      // Fall back to the global voucher-types list when the per-branch
      // endpoint fails — matches the old cubit's nested try/catch.
      (_) async {
        final globalResult = await _dataSource.getBondTypes();
        globalResult.fold(
          (failure) => emit(state.copyWith(
            bondTypesStatus: Status.failure,
            errorMessage: failure.message,
          )),
          (bondTypes) => _emitBondTypes(bondTypes, emit),
        );
      },
      (bondTypes) async => _emitBondTypes(bondTypes, emit),
    );
  }

  void _emitBondTypes(
      List<BondTypeModel> bondTypes, Emitter<InvoiceCollectionState> emit) {
    final first = bondTypes.isNotEmpty ? bondTypes.first : null;
    emit(state.copyWith(
      bondTypesStatus: Status.success,
      bondTypes: bondTypes,
      selectedVoucherType: first?.voucherType ?? 0,
      selectedBankName: first?.customerName ?? '',
    ));
  }

  // ── Branch changed → reload bond types ───────────────────────────────
  Future<void> _onBranchChanged(
    CollectionBranchChanged event,
    Emitter<InvoiceCollectionState> emit,
  ) async {
    emit(state.copyWith(
      selectedBranchId: event.branchId,
      bondTypesStatus: Status.loading,
    ));
    await _loadBondTypes(event.branchId, emit);
  }

  void _onCurrencyChanged(
    CollectionCurrencyChanged event,
    Emitter<InvoiceCollectionState> emit,
  ) {
    emit(state.copyWith(
      selectedCurrencyId: event.currencyId,
      selectedCurrencyRate: event.rate,
    ));
  }

  void _onPayWayChanged(
    CollectionPayWayChanged event,
    Emitter<InvoiceCollectionState> emit,
  ) {
    emit(state.copyWith(selectedCodePw: event.codePw));
  }

  void _onBondTypeChanged(
    CollectionBondTypeChanged event,
    Emitter<InvoiceCollectionState> emit,
  ) {
    emit(state.copyWith(
      selectedVoucherType: event.voucherType,
      selectedBankName: event.bankName,
    ));
  }

  void _onInvoiceLinked(
    CollectionInvoiceLinked event,
    Emitter<InvoiceCollectionState> emit,
  ) {
    emit(state.copyWith(
      invoiceId: event.invoiceId,
      invoiceNo: event.invoiceNo,
      voucherValue: event.voucherValue,
      customerName: event.customerName,
      acId: event.acId,
    ));
  }

  void _onCustomerSearched(
    CollectionCustomerSearched event,
    Emitter<InvoiceCollectionState> emit,
  ) {
    emit(state.copyWith(
      acId: event.acId,
      customerName: event.acName,
    ));
  }

  // ── Submit ────────────────────────────────────────────────────────────
  Future<void> _onSubmit(
    SubmitCollection event,
    Emitter<InvoiceCollectionState> emit,
  ) async {
    emit(state.copyWith(submitStatus: Status.loading));
    final result = await _dataSource.addCollection(event.request);
    result.fold(
      (failure) {
        // failure.message is the decrypted server text (e.g. "Not Found
        // Voucher" or an Arabic business error) — postData<String> already
        // hands those back as Left(ServerFailure).
        debugPrint('Invoice collection submission failed: ${failure.message}');
        emit(state.copyWith(
          submitStatus: Status.failure,
          errorMessage: failure.message,
        ));
      },
      (voucher) => emit(state.copyWith(
        submitStatus: Status.success,
        voucherResponse: voucher,
      )),
    );
  }

  // ── Edit (defined but unused in the first cut) ───────────────────────
  Future<void> _onEdit(
    EditCollection event,
    Emitter<InvoiceCollectionState> emit,
  ) async {
    emit(state.copyWith(submitStatus: Status.loading));
    final result = await _dataSource.editCollection(event.request);
    result.fold(
      (failure) => emit(state.copyWith(
        submitStatus: Status.failure,
        errorMessage: failure.message,
      )),
      (voucher) => emit(state.copyWith(
        submitStatus: Status.success,
        voucherResponse: voucher,
      )),
    );
  }
}
