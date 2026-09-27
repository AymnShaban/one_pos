
import 'package:equatable/equatable.dart';

import '../../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../../../main/main_reports/shared/store/data/models/store_model.dart';
import '../../../data/models/add_stock_items_response.dart';

class StockState extends Equatable {
final BaseState<List<StoreModel>> storesState;
final BaseState<AddStockItemsResponse> addStockState;

StockState({
BaseState<List<StoreModel>>? storesState,
BaseState<AddStockItemsResponse>? addStockState,
})  : storesState =
storesState ?? BaseState<List<StoreModel>>(),
addStockState =
addStockState ?? BaseState<AddStockItemsResponse>();

StockState copyWith({
BaseState<List<StoreModel>>? storesState,
BaseState<AddStockItemsResponse>? addStockState,
}) {
return StockState(
storesState: storesState ?? this.storesState,
addStockState: addStockState ?? this.addStockState,
);
}

@override
List<Object?> get props => [
storesState,
addStockState,
];
}

