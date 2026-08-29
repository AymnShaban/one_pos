import '../../../branch_profit_import.dart';

class BranchProfitBloc
    extends Bloc<BranchProfitEvent, BaseState<BranchProfitResponseModel>> {
  final BranchProfitDataSource dataSource;

  BranchProfitBloc({required this.dataSource})
      : super(const BaseState<BranchProfitResponseModel>()) {
    on<LoadBranchProfitReport>(_onLoadBranchProfitReport);
    on<ClearBranchProfitReport>(_onClearBranchProfitReport);
  }

  Future<void> _onLoadBranchProfitReport(
      LoadBranchProfitReport event,
      Emitter<BaseState<BranchProfitResponseModel>> emit,
      ) async {
    emit(state.copyWith(
      status: Status.loading,
      errorMessage: null,
      data: null,
    ));

    final result = await dataSource.getReport(event.request);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (report) => emit(
        state.copyWith(
          status: Status.success,
          data: report,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }

  void _onClearBranchProfitReport(
      ClearBranchProfitReport event,
      Emitter<BaseState<BranchProfitResponseModel>> emit,
      ) {
    emit(const BaseState<BranchProfitResponseModel>(
      status: Status.initial,
    ));
  }
}