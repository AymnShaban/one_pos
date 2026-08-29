import '../../../receipts_and_payments_movement_report_import.dart';
class VouchersBloc extends Bloc<VouchersEvent, VouchersState> {
  final VouchersDataSource dataSource;

  VouchersBloc({required this.dataSource}) : super(const VouchersState()) {
    on<LoadVouchersReport>(_onLoadVouchersReport);
    on<ClearVouchersReport>(_onClearVouchersReport);
  }

  Future<void> _onLoadVouchersReport(
      LoadVouchersReport event,
      Emitter<VouchersState> emit,
      ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
        clearData: true,
      ),
    );

    final result = await dataSource.getReport(event.request);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (data) => emit(
        state.copyWith(
          status: Status.success,
          data: data,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }

  void _onClearVouchersReport(
      ClearVouchersReport event,
      Emitter<VouchersState> emit,
      ) {
    emit(const VouchersState(status: Status.initial));
  }
}