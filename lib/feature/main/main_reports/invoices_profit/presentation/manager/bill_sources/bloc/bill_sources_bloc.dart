import '../../../../data/datasource/bill_sources_datasource.dart';
import '../../../../invoice_profit_imports.dart';
class BillSourcesBloc extends Bloc<BillSourcesEvent, BillSourcesState> {
  final BillSourcesDataSource dataSource;

  BillSourcesBloc({required this.dataSource}) : super(const BillSourcesState()) {
    on<LoadBillSources>(_onLoadBillSources);
    on<SelectBillSource>(_onSelectBillSource);
  }

  Future<void> _onLoadBillSources(
      LoadBillSources event,
      Emitter<BillSourcesState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getBillSources();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (billSources) {

        final List<BillSourceModel> allSources = [
          BillSourceModel(
            code: 0,
            arName: "الكل",
            latinName: "All",
          ),
          ...billSources,
        ];


        emit(
          state.copyWith(
            status: Status.success,
            billSources: allSources,
            selectedBillSourceId: 0,
            isAllSelected: true,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectBillSource(
      SelectBillSource event,
      Emitter<BillSourcesState> emit,
      ) {
    // لو اختار "الكل" (ID = 0)، نخلي isAllSelected = true
    // لو اختار غيره، نخلي isAllSelected = false
    emit(
      state.copyWith(
        selectedBillSourceId: event.billSourceId,
        isAllSelected: event.billSourceId == 0,
      ),
    );
  }
}