import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_pos/feature/barren/presentation/cubit/stock_cubit/stock_state.dart';

import '../../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../../data/datasource/stock_datasource.dart';
import '../../../data/models/add_stock_items_request.dart';
import '../../../data/models/add_stock_items_response.dart';

class StockCubit extends Cubit<StockState> {
  final StockDataSource _dataSource;

  StockCubit(this._dataSource) : super(StockState());

  Future<void> getStores() async {
    emit(
      state.copyWith(
        storesState: state.storesState.copyWith(
          status: Status.loading,
          failure: null,
          errorMessage: null,
        ),
      ),
    );

    final result = await _dataSource.getStores();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            storesState: state.storesState.copyWith(
              status: Status.failure,
              failure: failure,
              errorMessage: failure.toString(),
            ),
          ),
        );
      },
      (stores) {
        emit(
          state.copyWith(
            storesState: state.storesState.copyWith(
              status: Status.success,
              data: stores,
              failure: null,
              errorMessage: null,
              lastUpdated: DateTime.now(),
            ),
          ),
        );
      },
    );
  }

  Future<void> addStockItems(AddStockItemsRequest request) async {
    emit(
      state.copyWith(
        addStockState: state.addStockState.copyWith(
          status: Status.loading,
          failure: null,
          errorMessage: null,
        ),
      ),
    );

    final result = await _dataSource.addStockItems(request);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            addStockState: state.addStockState.copyWith(
              status: Status.failure,
              failure: failure,
              errorMessage: failure.toString(),
            ),
          ),
        );
      },
      (response) {
        if (!response.success) {
          emit(
            state.copyWith(
              addStockState: state.addStockState.copyWith(
                status: Status.failure,
                data: response,
                errorMessage: response.message,
              ),
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            addStockState: state.addStockState.copyWith(
              status: Status.success,
              data: response,
              failure: null,
              errorMessage: null,
              lastUpdated: DateTime.now(),
            ),
          ),
        );
      },
    );
  }

  void resetAddStockState() {
    emit(state.copyWith(addStockState: BaseState<AddStockItemsResponse>()));
  }
}
