import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../models/home_stats_model.dart';
import 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, BaseState<HomeStatsModel>> {
  bool isOnline = true;
  bool isSynced = true;

  HomeBloc() : super(const BaseState()) {
    on<InitHome>(_onInit);
    on<ToggleSyncMode>(_onToggleSync);
    on<CheckConnectivity>(_onCheckConnectivity);
  }

  void _onInit(InitHome event, Emitter<BaseState<HomeStatsModel>> emit) {
    emit(state.copyWith(
      status: Status.success,
      items: [
        const HomeStatsModel(
          todaySales: 12450,
          invoicesCount: 34,
          productsCount: 289,
          invoicesNewCount: 5,
          salesPercentage: 12,
        ),
      ],
    ));
  }

  void _onToggleSync(ToggleSyncMode event, Emitter<BaseState<HomeStatsModel>> emit) {
    isSynced = !isSynced;
    emit(state.copyWith(status: Status.success));
  }

  void _onCheckConnectivity(CheckConnectivity event, Emitter<BaseState<HomeStatsModel>> emit) {
    emit(state.copyWith(status: Status.success));
  }
}