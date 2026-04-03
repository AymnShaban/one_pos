part of '../../favorite_imports.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, BaseState<FavoriteModel>> {
  final FavoriteDataSource _favoriteDataSource;

  FavoriteBloc({required FavoriteDataSource favoriteDataSource})
    : _favoriteDataSource = favoriteDataSource,
      super(const BaseState<FavoriteModel>()) {
    on<AddFavorite>(_onAddFavorite);
    on<DeleteFavorite>(_onDeleteFavorite);
    on<GetFavorite>(_onGetFavorite);
    on<ResetFavoriteState>(_onResetFavoriteState);
  }

  Future<void> _onAddFavorite(
    AddFavorite event,
    Emitter<BaseState<FavoriteModel>> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        metadata: {'action': 'add', 'productId': event.request.productID},
      ),
    );

    final result = await _favoriteDataSource.addFavorite(event.request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'add', 'productId': event.request.productID},
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: Status.success,
          metadata: {'action': 'add', 'productId': event.request.productID},
        ),
      ),
    );
  }

  Future<void> _onDeleteFavorite(
    DeleteFavorite event,
    Emitter<BaseState<FavoriteModel>> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        metadata: {'action': 'delete', 'productId': event.request.productID},
      ),
    );

    final result = await _favoriteDataSource.deleteFavorite(event.request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'delete', 'productId': event.request.productID},
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: Status.success,
          metadata: {'action': 'delete', 'productId': event.request.productID},
        ),
      ),
    );
  }

  Future<void> _onGetFavorite(
    GetFavorite event,
    Emitter<BaseState<FavoriteModel>> emit,
  ) async {
    print('GetFavorite: customerPhone=${event.customerPhone}');
    emit(state.copyWith(status: Status.loading, metadata: {'action': 'fetch'}));

    final result = await _favoriteDataSource.getFavorite(
      customerPhone: event.customerPhone,
    );

    result.fold(
      (failure) {
        print('GetFavorite failed: ${failure.message}');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
            metadata: {'action': 'fetch'},
          ),
        );
      },
      (items) {
        print(
          'GetFavorite succeeded: ${items.length} items, IDs=${items.map((e) => e.productID).toList()}',
        );
        emit(
          state.copyWith(
            status: Status.success,
            items: List.from(items),
            metadata: {'action': 'fetch'},
          ),
        );
      },
    );
  }

  Future<void> _onResetFavoriteState(
    ResetFavoriteState event,
    Emitter<BaseState<FavoriteModel>> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.initial,
        failure: null,
        errorMessage: null,
        metadata: {},
      ),
    );
  }
}
