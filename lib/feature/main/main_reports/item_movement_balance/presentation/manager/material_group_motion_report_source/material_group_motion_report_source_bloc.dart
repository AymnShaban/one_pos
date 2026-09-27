import '../../../item_movement_balance_import.dart';
class MaterialGroupMotionReportSourceBloc
    extends Bloc<
        MaterialGroupMotionReportSourceEvent,
        MaterialGroupMotionReportSourceState> {
  final MaterialGroupMotionReportSourceDataSource dataSource;

  MaterialGroupMotionReportSourceBloc({
    required this.dataSource,
  }) : super(
    const MaterialGroupMotionReportSourceState(),
  ) {
    on<LoadMaterialGroupMotionReportSources>(
      _onLoadMaterialGroupMotionReportSources,
    );

    on<SelectMaterialGroupMotionReportSource>(
      _onSelectMaterialGroupMotionReportSource,
    );
  }

  Future<void> _onLoadMaterialGroupMotionReportSources(
      LoadMaterialGroupMotionReportSources event,
      Emitter<MaterialGroupMotionReportSourceState> emit,
      ) async {
    emit(
      state.copyWith(
        status: Status.loading,
      ),
    );

    final result =
    await dataSource.getMaterialGroupMotionReportSources();

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
          ),
        );
      },
          (items) {
        final firstId =
        items.isNotEmpty ? items.first.frmNum : null;

        final allIds =
        items.map((e) => e.frmNum).toSet();

        emit(
          state.copyWith(
            status: Status.success,
            items: items,
            selectedItem: firstId,
            selectedItems: allIds,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectMaterialGroupMotionReportSource(
      SelectMaterialGroupMotionReportSource event,
      Emitter<MaterialGroupMotionReportSourceState> emit,
      ) {
    final frmNum = event.frmNum;

    final exists = state.items.any(
          (e) => e.frmNum == frmNum,
    );

    if (exists) {
      emit(
        state.copyWith(
          selectedItem: frmNum,
          selectedItems: {frmNum},
        ),
      );
    }
  }
}