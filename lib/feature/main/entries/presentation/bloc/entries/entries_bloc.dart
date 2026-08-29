import  '../../../entries_imports.dart';

class EntriesBloc extends Bloc<EntriesEvent, BaseState<List<VoucherTypeModel>>> {
  final EntriesDataSource _dataSource;

  // Extra data stored outside state to avoid rebuilding
  List<VoucherTypeModel>? _voucherTypes;
  VoucherTypeModel? _voucherTypeDetails;
  VoucherTypeModel? _voucherDetails;

  EntriesBloc({
    required EntriesDataSource dataSource,
  })  : _dataSource = dataSource,
        super(const BaseState<List<VoucherTypeModel>>()) {
    on<LoadVoucherTypes>(_onLoadVoucherTypes);
    on<LoadVouchers>(_onLoadVouchers);
    on<LoadVoucherTypeDetails>(_onLoadVoucherTypeDetails);
    on<LoadVoucherById>(_onLoadVoucherById);
    on<ClearEntries>(_onClearEntries);
  }


  List<VoucherTypeModel>? get voucherTypes => _voucherTypes;
  VoucherTypeModel? get voucherTypeDetails => _voucherTypeDetails;
  VoucherTypeModel? get voucherDetails => _voucherDetails;

  Future<void> _onLoadVoucherTypes(
      LoadVoucherTypes event,
      Emitter<BaseState<List<VoucherTypeModel>>> emit,
      ) async {
    if (state.status == Status.loading) return;

    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
      ),
    );

    final result = await _dataSource.getVoucherTypes();

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
            failure: failure,
          ),
        );
      },
          (types) {
        _voucherTypes = types;
        emit(
          state.copyWith(
            status: Status.success,
            data: state.data, // Keep existing data
            errorMessage: null,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> _onLoadVouchers(
      LoadVouchers event,
      Emitter<BaseState<List<VoucherTypeModel>>> emit,
      ) async {
    if (state.status == Status.loading) return;

    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
      ),
    );

    final result = await _dataSource.getVouchers(event.vouchTypeId);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
            failure: failure,
          ),
        );
      },
          (vouchers) {
        emit(
          state.copyWith(
            status: Status.success,
            data: vouchers,
            errorMessage: null,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> _onLoadVoucherTypeDetails(
      LoadVoucherTypeDetails event,
      Emitter<BaseState<List<VoucherTypeModel>>> emit,
      ) async {
    if (state.status == Status.loading) return;

    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
      ),
    );

    final result = await _dataSource.getVoucherTypeDetails(event.frmNum);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
            failure: failure,
          ),
        );
      },
          (details) {
        _voucherTypeDetails = details;
        emit(
          state.copyWith(
            status: Status.success,
            data: state.data, // Keep existing data
            errorMessage: null,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> _onLoadVoucherById(
      LoadVoucherById event,
      Emitter<BaseState<List<VoucherTypeModel>>> emit,
      ) async {
    if (state.status == Status.loading) return;

    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
      ),
    );
  }

  void _onClearEntries(
      ClearEntries event,
      Emitter<BaseState<List<VoucherTypeModel>>> emit,
      ) {
    _voucherTypes = null;
    _voucherTypeDetails = null;
    _voucherDetails = null;
    emit(const BaseState<List<VoucherTypeModel>>());
  }
}