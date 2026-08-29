
import '../../../shared_imports.dart';

class ProductsBloc extends Bloc<ProductsEvent, BaseState<List<ProductModel>>> {
  final ProductsDataSource dataSource;

  ProductsBloc({required this.dataSource})
      : super(const BaseState<List<ProductModel>>()) {
    on<LoadProducts>(_onLoadProducts);
    on<ClearProducts>(_onClearProducts);
  }

  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<BaseState<List<ProductModel>>> emit,
      ) async {
    emit(state.copyWith(
      status: Status.loading,
      errorMessage: null,
      data: null,
    ));

    final result = await dataSource.getProducts(search: event.search);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (products) => emit(
        state.copyWith(
          status: Status.success,
          data: products,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }

  void _onClearProducts(
      ClearProducts event,
      Emitter<BaseState<List<ProductModel>>> emit,
      ) {
    emit(const BaseState<List<ProductModel>>());
  }
}