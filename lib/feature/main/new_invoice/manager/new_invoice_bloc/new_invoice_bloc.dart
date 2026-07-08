part of '../../new_invoice_imports.dart';

class NewInvoiceState {
  final BaseState<PaymentWayModel> payWaysState;
  final int lastInvoiceNumber;
  final int patternId;
  final int branchId;
  final int currencyId;
  final double currencyRate;
  final Status submitStatus;
  final String? errorMessage;
  final String? successData; // decrypted invoice JSON on success

  const NewInvoiceState({
    this.payWaysState = const BaseState(),
    this.lastInvoiceNumber = 0,
    this.patternId = -1,
    this.branchId = 0,
    this.currencyId = 1,
    this.currencyRate = 1,
    this.submitStatus = Status.initial,
    this.errorMessage,
    this.successData,
  });

  NewInvoiceState copyWith({
    BaseState<PaymentWayModel>? payWaysState,
    int? lastInvoiceNumber,
    int? patternId,
    int? branchId,
    int? currencyId,
    double? currencyRate,
    Status? submitStatus,
    String? errorMessage,
    String? successData,
  }) {
    return NewInvoiceState(
      payWaysState: payWaysState ?? this.payWaysState,
      lastInvoiceNumber: lastInvoiceNumber ?? this.lastInvoiceNumber,
      patternId: patternId ?? this.patternId,
      branchId: branchId ?? this.branchId,
      currencyId: currencyId ?? this.currencyId,
      currencyRate: currencyRate ?? this.currencyRate,
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      successData: successData ?? this.successData,
    );
  }
}

class NewInvoiceBloc extends Bloc<NewInvoiceEvent, NewInvoiceState> {
  final NewInvoiceDataSource _dataSource;

  NewInvoiceBloc({required NewInvoiceDataSource dataSource})
    : _dataSource = dataSource,
      super(const NewInvoiceState()) {
    on<LoadPayWays>(_onLoadPayWays);
    on<LoadLastInvoiceId>(_onLoadLastId);
    on<SubmitInvoice>(_onSubmit);
    on<EditInvoice>(_onEdit);
    on<UpdatePatternId>(_onUpdatePattern);
    on<UpdateBranchId>(_onUpdateBranch);
    on<UpdateCurrency>(_onUpdateCurrency);
    on<CreateInvoiceFromSales>(_onCreateFromSales);
  }

  Future<void> _onLoadPayWays(
    LoadPayWays event,
    Emitter<NewInvoiceState> emit,
  ) async {
    emit(
      state.copyWith(
        payWaysState: state.payWaysState.copyWith(status: Status.loading),
      ),
    );
    final result = await _dataSource.getPayWays();
    result.fold(
      (failure) => emit(
        state.copyWith(
          payWaysState: state.payWaysState.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
          ),
        ),
      ),
      (data) => emit(
        state.copyWith(
          payWaysState: state.payWaysState.copyWith(
            status: Status.success,
            items: data,
          ),
        ),
      ),
    );
  }

  Future<void> _onLoadLastId(
    LoadLastInvoiceId event,
    Emitter<NewInvoiceState> emit,
  ) async {
    final result = await _dataSource.getLastInvoiceId(event.patternId);
    result.fold((_) {}, (id) => emit(state.copyWith(lastInvoiceNumber: id)));
  }

  Future<void> _onSubmit(
    SubmitInvoice event,
    Emitter<NewInvoiceState> emit,
  ) async {
    emit(state.copyWith(submitStatus: Status.loading));
    final result = await _dataSource.createInvoice(event.request);
    result.fold(
      (failure) {
        debugPrint('Invoice submission failed: ${failure.message}');
        logger(failure.message);
        emit(
          state.copyWith(
            submitStatus: Status.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (data) =>
          emit(state.copyWith(submitStatus: Status.success, successData: data)),
    );
  }

  Future<void> _onEdit(EditInvoice event, Emitter<NewInvoiceState> emit) async {
    emit(state.copyWith(submitStatus: Status.loading));
    final result = await _dataSource.editInvoice(event.request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          submitStatus: Status.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) =>
          emit(state.copyWith(submitStatus: Status.success, successData: data)),
    );
  }

  void _onUpdatePattern(UpdatePatternId event, Emitter<NewInvoiceState> emit) {
    emit(state.copyWith(patternId: event.patternId));
    add(LoadLastInvoiceId(event.patternId));
  }

  void _onUpdateBranch(UpdateBranchId event, Emitter<NewInvoiceState> emit) {
    emit(state.copyWith(branchId: event.branchId));
  }

  void _onUpdateCurrency(UpdateCurrency event, Emitter<NewInvoiceState> emit) {
    emit(
      state.copyWith(currencyId: event.currencyId, currencyRate: event.rate),
    );
  }

  Future<void> _onCreateFromSales(
    CreateInvoiceFromSales event,
    Emitter<NewInvoiceState> emit,
  ) async {
    emit(state.copyWith(submitStatus: Status.loading));

    final items = event.basketItems.asMap().entries.map((entry) {
      return entry.value.toCartItem(rowNumber: entry.key + 1);
    }).toList();

    final request = CreateInvoiceRequest(
      invoicePatternId: event.patternId,
      // ASP.NET's `System.Text.Json` deserializer only accepts ISO 8601 for
      // `DateTime`; the old `yyyy/MM/dd` shape 400s ("could not be converted
      // to System.Nullable<DateTime>") and cascades into a null model that
      // trips "The invoice field is required." Date-only ISO (`yyyy-MM-dd`)
      // is what the server was verified to accept.
      invoiceDate: DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now()),
      companyBranchId: event.branchId,
      remainder: 0,
      currencyId: event.currencyId,
      currencyRate: event.rate.toDouble(),
      customerId: event.customerId,
      totalValue: event.totalValue,
      totalAddition: 0,
      totalDiscount: 0,
      finalValue: event.totalValue,
      payingType: 0,
      // Cache ?
      prePaid: event.totalValue,
      createdBy: event.createdBy,
      items: items,
      payWays: [
        PayReceiptModel(
          payingValue: event.totalValue,
          payingType: 0,
          payWayName: 'Cash',
          payWayEnName: 'Cash',
        ),
      ],
    );

    final result = await _dataSource.createInvoice(request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          submitStatus: Status.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) =>
          emit(state.copyWith(submitStatus: Status.success, successData: data)),
    );
  }
}
