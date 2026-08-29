import '../../../shared_imports.dart';
class CostCentersBloc extends Bloc<CostCentersEvent, CostCentersState> {
  final CostCentersDataSource dataSource;

  CostCentersBloc({required this.dataSource}) : super(const CostCentersState()) {
    on<LoadCostCenters>(_onLoadCostCenters);
    on<SelectCostCenter>(_onSelectCostCenter);
  }

  Future<void> _onLoadCostCenters(
      LoadCostCenters event,
      Emitter<CostCentersState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getCostCenters();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (costCenters) {

        emit(
          state.copyWith(
            status: Status.success,
            costCenters: costCenters,
            selectedCostCenterId: null,
            selectedCostCenterIds: null,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectCostCenter(
      SelectCostCenter event,
      Emitter<CostCentersState> emit,
      ) {
    final costCenterId = event.costCenterId;

    // ✅ نتأكد إن مركز التكلفة موجود
    final exists = state.costCenters.any((c) => c.coID == costCenterId);

    if (exists) {
      emit(
        state.copyWith(
          selectedCostCenterId: costCenterId,
          selectedCostCenterIds: {costCenterId},
        ),
      );
    }
  }
}
