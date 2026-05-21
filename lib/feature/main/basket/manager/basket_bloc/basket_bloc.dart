part of '../../basket_imports.dart';

class BasketBloc extends Bloc<BasketEvent, BaseState<ItemModel>> {
  final BasketDataSource _basketDataSource;
  final DeleteBasketDataSource _deleteBasketDataSource;

  BasketBloc({
    required BasketDataSource basketDataSource,
    required DeleteBasketDataSource deleteBasketDataSource,
  }) : _basketDataSource = basketDataSource,
        _deleteBasketDataSource = deleteBasketDataSource,
        super(const BaseState<ItemModel>()) {
    on<FetchBasketItems>(_onFetchBasketItems);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<DeleteBasketItem>(_onDeleteBasketItem);
    on<ClearBasket>(_onClearBasket);
  }

  Future<void> _onFetchBasketItems(
      FetchBasketItems event,
      Emitter<BaseState<ItemModel>> emit,
      ) async {
    emit(state.copyWith(status: Status.loading, metadata: {'action': 'fetch'}));

    final result = await _basketDataSource.getBasketItems();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'fetch'},
        ),
      ),
          (items) {
            debugPrint("items for basket ${items.map((e)=>e.toJson())}");
            emit(
        state.copyWith(
          status: Status.success,
          items: items,
          metadata: {'action': 'fetch'},
        ),
      );
          },
    );
  }

  Future<void> _onUpdateQuantity(
      UpdateQuantity event,
      Emitter<BaseState<ItemModel>> emit,
      ) async {
    final currentItems = state.items;
    final index = currentItems.indexWhere(
          (item) => item.productId == event.productId,
    );
    if (index >= 0) {
      final newQuantity = event.newQuantity.clamp(0, 100);
      emit(
        state.copyWith(
          status: Status.loading,
          metadata: {'action': 'update', 'productId': event.productId},
        ),
      );

      if (newQuantity == 0) {
        final result = await _deleteBasketDataSource.deleteBasketItem(
          event.productId,
          event.barCode
        );
        result.fold(
              (failure) => emit(
            state.copyWith(
              status: Status.failure,
              failure: failure,
              errorMessage: failure.message,
              metadata: {'action': 'update', 'productId': event.productId},
            ),
          ),
              (_) => emit(
            state.copyWith(
              status: Status.success,
              items: currentItems
                  .where((item) => item.productId != event.productId)
                  .toList(),
              metadata: {'action': 'update', 'productId': event.productId},
            ),
          ),
        );
      } else {
        final updatedItems = List<ItemModel>.from(currentItems);
        updatedItems[index] = updatedItems[index].copyWith(
          salesQuantity: newQuantity,
        );
        emit(
          state.copyWith(
            status: Status.success,
            items: updatedItems,
            metadata: {'action': 'update', 'productId': event.productId},
          ),
        );
      }
    }
  }

  Future<void> _onDeleteBasketItem(
      DeleteBasketItem event,
      Emitter<BaseState<ItemModel>> emit,
      ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        metadata: {'action': 'delete', 'productId': event.productId},
      ),
    );

    final result = await _deleteBasketDataSource.deleteBasketItem(
      event.productId,
      event.productBarcode
    );

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'delete', 'productId': event.productId},
        ),
      ),
          (_) {
        final currentItems = state.items;
        final index = currentItems.indexWhere(
              (item) => item.productId == event.productId,
        );
        if (index >= 0) {
          final currentQuantity = currentItems[index].salesQuantity;
          final newQuantity = (currentQuantity - 1).clamp(0, 100);
          if (newQuantity == 0) {
            emit(
              state.copyWith(
                status: Status.success,
                items: currentItems
                    .where((item) => item.productId != event.productId)
                    .toList(),
                metadata: {'action': 'delete', 'productId': event.productId},
              ),
            );
          } else {
            final updatedItems = List<ItemModel>.from(currentItems);
            updatedItems[index] = updatedItems[index].copyWith(
              salesQuantity: newQuantity,
            );
            emit(
              state.copyWith(
                status: Status.success,
                items: updatedItems,
                metadata: {'action': 'delete', 'productId': event.productId},
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _onClearBasket(
      ClearBasket event,
      Emitter<BaseState<ItemModel>> emit,
      ) async {
    // Wipe the local Hive cache so a later fetch can't reload the sold items,
    // then reset to an empty state.
    await _deleteBasketDataSource.clearBasket();
    emit(const BaseState());
  }
}
