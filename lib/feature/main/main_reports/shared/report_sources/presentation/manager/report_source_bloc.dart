import '../../../shared_imports.dart';
class ReportSourceBloc extends Bloc<ReportSourceEvent, ReportSourceState> {
  final ReportSourceDataSource dataSource;

  ReportSourceBloc({required this.dataSource}) : super(const ReportSourceState()) {
    on<LoadReportSources>(_onLoadReportSources);
    on<SelectReportSource>(_onSelectReportSource);
  }

  Future<void> _onLoadReportSources(
      LoadReportSources event,
      Emitter<ReportSourceState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getReportSources();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (items) {

        final firstId = items.isNotEmpty ? items.first.frmNum : null;

        final allIds = items.map((e) => e.frmNum).toSet();

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

  void _onSelectReportSource(
      SelectReportSource event,
      Emitter<ReportSourceState> emit,
      ) {
    final frmNum = event.frmNum;


    final exists = state.items.any((e) => e.frmNum == frmNum);

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