part of '../../home_imports.dart';

class HomeBloc extends Bloc<HomeEvent, BaseState<HomeStatsModel>> {
  final DashboardDataSource _dashboard;
  bool isOnline = true;
  bool isSynced = true;

  // Cached so the redesigned weekly-trend chart can read the real series
  // once it's wired — the StatCards only need the scalar mappings.
  DashboardBalancesModel? balances;

  HomeBloc({required DashboardDataSource dashboard})
      : _dashboard = dashboard,
        super(const BaseState()) {
    on<InitHome>(_onInit);
    on<ToggleSyncMode>(_onToggleSync);
    on<CheckConnectivity>(_onCheckConnectivity);
  }

  Future<void> _onInit(
    InitHome event,
    Emitter<BaseState<HomeStatsModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dashboard.getBalances();
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
      (data) {
        balances = data;
        // Map the API shape onto the StatCards:
        //   Sales         ← salesTotal
        //   Costs         ← suppliersBalance (money owed to suppliers — the
        //                   closest "costs" signal in this payload)
        //   Daily Sales   ← today's entry from dailySales
        emit(state.copyWith(
          status: Status.success,
          items: [
            HomeStatsModel(
              todaySales: data.todayTotal,
              totalRevenue: data.salesTotal,
              totalExpenses: data.suppliersBalance,
              netProfit: data.salesTotal - data.suppliersBalance,
            ),
          ],
        ));
      },
    );
  }

  void _onToggleSync(
    ToggleSyncMode event,
    Emitter<BaseState<HomeStatsModel>> emit,
  ) {
    isSynced = !isSynced;
    emit(state.copyWith(status: Status.success));
  }

  void _onCheckConnectivity(
    CheckConnectivity event,
    Emitter<BaseState<HomeStatsModel>> emit,
  ) {
    emit(state.copyWith(status: Status.success));
  }
}
