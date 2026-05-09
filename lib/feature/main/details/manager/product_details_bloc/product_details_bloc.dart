import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../data_source/product_details_data_source.dart';
import '../../models/products_details_model.dart';
import 'product_details_event.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, BaseState<ProductDetailsModel>> {
  final ProductDetailsDataSource _dataSource;

  ProductDetailsBloc({required ProductDetailsDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<ProductDetailsModel>()) {
    on<FetchProductDetails>(_onFetchProductDetails);
  }

  Future<void> _onFetchProductDetails(
      FetchProductDetails event,
      Emitter<BaseState<ProductDetailsModel>> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.getProductDetails(
      productId: event.productId,
      customerPhone: event.customerPhone,
      customerId: event.customerId,
    );

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
          (product) => emit(
        state.copyWith(
          status: Status.success,
          data: product,
        ),
      ),
    );
  }
}