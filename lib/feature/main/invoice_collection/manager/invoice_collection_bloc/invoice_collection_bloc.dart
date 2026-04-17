part of '../../invoice_collection_imports.dart';


// ── Bloc ──────────────────────────────────────────────────────────────────────
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

  // ── Load all setup data ───────────────────────────────────────────────────
  Future<void> _onLoadSetup(
      LoadCollectionSetupData event,
      Emitter<InvoiceCollectionState> emit,
      ) async {
    emit(state.copyWith(
      branchesStatus:   Status.loading,
      currenciesStatus: Status.loading,
      payWaysStatus:    Status.loading,
      bondTypesStatus:  Status.loading,
    ));

    // ── Branches ──
    try {
      final branches = await _dataSource.getBranches();
      final firstBranchId =
      branches.isNotEmpty ? branches.first['ID'] as int : 0;
      emit(state.copyWith(
        branchesStatus:   Status.success,
        branches:         branches,
        selectedBranchId: firstBranchId,
      ));

      // Load bond types for the first branch
      if (firstBranchId != 0) {
        _loadBondTypes(firstBranchId, emit);
      }
    } catch (e) {
      emit(state.copyWith(
        branchesStatus: Status.failure,
        errorMessage:   e.toString(),
      ));
    }

    // ── Currencies ──
    try {
      final currencies = await _dataSource.getCurrencies();
      final defaultCurrency = currencies.isNotEmpty ? currencies.first : null;
      emit(state.copyWith(
        currenciesStatus:     Status.success,
        currencies:           currencies,
        selectedCurrencyId:   defaultCurrency?['CurrencyID'] ?? 0,
        selectedCurrencyRate: (defaultCurrency?['Rate'] ?? 1.0).toDouble(),
      ));
    } catch (e) {
      emit(state.copyWith(
        currenciesStatus: Status.failure,
        errorMessage:     e.toString(),
      ));
    }

    // ── Pay Ways ──
    try {
      final payWays = await _dataSource.getPayWays();
      emit(state.copyWith(
        payWaysStatus: Status.success,
        payWays:       payWays,
        selectedCodePw: payWays.isNotEmpty
            ? (payWays.first['Code_PW'] as num).toInt()
            : 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        payWaysStatus: Status.failure,
        errorMessage:  e.toString(),
      ));
    }
  }

  Future<void> _loadBondTypes(
      int branchId,
      Emitter<InvoiceCollectionState> emit,
      ) async {
    try {
      final bondTypes = await _dataSource.getBondTypesByBranch(branchId);
      final first = bondTypes.isNotEmpty ? bondTypes.first : null;
      emit(state.copyWith(
        bondTypesStatus:     Status.success,
        bondTypes:           bondTypes,
        selectedVoucherType: first?.voucherType ?? 0,
        selectedBankName:    first?.customerName ?? '',
      ));
    } catch (e) {
      // Fallback to global bond types
      try {
        final bondTypes = await _dataSource.getBondTypes();
        final first = bondTypes.isNotEmpty ? bondTypes.first : null;
        emit(state.copyWith(
          bondTypesStatus:     Status.success,
          bondTypes:           bondTypes,
          selectedVoucherType: first?.voucherType ?? 0,
          selectedBankName:    first?.customerName ?? '',
        ));
      } catch (e2) {
        emit(state.copyWith(
          bondTypesStatus: Status.failure,
          errorMessage:    e2.toString(),
        ));
      }
    }
  }

  // ── Branch changed → reload bond types ───────────────────────────────────
  Future<void> _onBranchChanged(
      CollectionBranchChanged event,
      Emitter<InvoiceCollectionState> emit,
      ) async {
    emit(state.copyWith(
      selectedBranchId: event.branchId,
      bondTypesStatus:  Status.loading,
    ));
    await _loadBondTypes(event.branchId, emit);
  }

  void _onCurrencyChanged(
      CollectionCurrencyChanged event,
      Emitter<InvoiceCollectionState> emit,
      ) {
    emit(state.copyWith(
      selectedCurrencyId:   event.currencyId,
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
      selectedBankName:    event.bankName,
    ));
  }

  void _onInvoiceLinked(
      CollectionInvoiceLinked event,
      Emitter<InvoiceCollectionState> emit,
      ) {
    emit(state.copyWith(
      invoiceId:    event.invoiceId,
      invoiceNo:    event.invoiceNo,
      voucherValue: event.voucherValue,
      customerName: event.customerName,
      acId:         event.acId,
    ));
  }

  void _onCustomerSearched(
      CollectionCustomerSearched event,
      Emitter<InvoiceCollectionState> emit,
      ) {
    emit(state.copyWith(
      acId:         event.acId,
      customerName: event.acName,
    ));
  }

  // ── Submit ────────────────────────────────────────────────────────────────
  Future<void> _onSubmit(
      SubmitCollection event,
      Emitter<InvoiceCollectionState> emit,
      ) async {
    emit(state.copyWith(submitStatus: Status.loading));
    try {
      final voucher = await _dataSource.addCollection(event.request);
      emit(state.copyWith(
        submitStatus:    Status.success,
        voucherResponse: voucher,
      ));
    } catch (e) {
      emit(state.copyWith(
        submitStatus: Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── Edit ──────────────────────────────────────────────────────────────────
  Future<void> _onEdit(
      EditCollection event,
      Emitter<InvoiceCollectionState> emit,
      ) async {
    emit(state.copyWith(submitStatus: Status.loading));
    try {
      final voucher = await _dataSource.editCollection(event.request);
      emit(state.copyWith(
        submitStatus:    Status.success,
        voucherResponse: voucher,
      ));
    } catch (e) {
      emit(state.copyWith(
        submitStatus: Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}