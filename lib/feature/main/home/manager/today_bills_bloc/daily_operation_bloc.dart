
import 'package:one_pos/feature/main/home/manager/today_bills_bloc/daily_operation_event.dart';

import '../../../../../core/helper/helper.dart';
import '../../home_imports.dart';
import '../../models/daily_operation_model.dart';

class DailyOperationsBloc extends Bloc<DailyOperationsEvent, BaseState<List<DailyOperationModel>>> {
  final DailyOperationDataSource _dataSource;
  bool isOnline = true;
  bool isSynced = true;

  DailyOperationsBloc({required DailyOperationDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState()) {
    on<LoadDailyOperations>(onLoadDailyOperations);
    on<RefreshDailyOperations>(_onRefreshDailyOperations);
    on<ClearDailyOperations>(_onClearDailyOperations);
  }

  Future<void> onLoadDailyOperations(
      LoadDailyOperations event,
      Emitter<BaseState<List<DailyOperationModel>>> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.getDailyOperations();

    result.fold(
          (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
          (bills) => emit(state.copyWith(
        status: Status.success,
data: bills,
      )),
    );
  }

  Future<void> _onRefreshDailyOperations(
      RefreshDailyOperations event,
      Emitter<BaseState<List<DailyOperationModel>>> emit,
      ) async {
    // If already loading, don't refresh
    if (state.status == Status.loading) return;

    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.getDailyOperations();

    result.fold(
          (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
          (bills) => emit(state.copyWith(
        status: Status.success,
        data: bills,

      )),
    );
  }

  void _onClearDailyOperations(
      ClearDailyOperations event,
      Emitter<BaseState<List<DailyOperationModel>>> emit,
      ) {
    emit(const BaseState());
  }
}