import '../../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_source/add_to_basket_data_source.dart';
import 'add_to_basket_events.dart';


class AddToBasketBloc extends Bloc<AddToBasketEvent, BaseState<void>> {
  final AddToBasketDataSource _addToBasketDataSource;

  AddToBasketBloc({required AddToBasketDataSource addToBasketDataSource})
      : _addToBasketDataSource = addToBasketDataSource,
        super(const BaseState<void>()) {
    on<AddToBasket>(_onAddToBasket);
  }

  Future<void> _onAddToBasket(
      AddToBasket event,
      Emitter<BaseState<void>> emit,
      ) async {
    emit(state.copyWith(
      status: Status.loading,
      metadata: {'action': 'add', 'productId': event.request.productID},
    ));

    final result = await _addToBasketDataSource.addToBasket(event.request);

    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        failure: failure,
        errorMessage: failure.message,
        metadata: {'action': 'add', 'productId': event.request.productID},
      )),
      (_) => emit(state.copyWith(
        status: Status.success,
        metadata: {'action': 'add', 'productId': event.request.productID},
      )),
    );

  }
}