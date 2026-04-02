import 'package:get_it/get_it.dart';
import '../../../../../../feature/main/basket/data_source/delete_basket_data_source.dart';
import '../../../../../../feature/main/basket/data_source/fetch_basket_items_data_source.dart';
import '../../../../feature/main/basket/data_source/add_to_basket_data_source.dart';
import '../../../../feature/main/basket/manager/add_to_basket_bloc/add_to_basket_bloc.dart';
import '../../../../feature/main/basket/manager/basket_bloc/basket_bloc.dart';
import '../../../datasource/generic_data_source.dart';

class BasketServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<BasketDataSource>(
      () => BasketDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<DeleteBasketDataSource>(
      () => DeleteBasketDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<AddToBasketDataSource>(
      () => AddToBasketDataSourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerLazySingleton<BasketBloc>(
      () => BasketBloc(
        basketDataSource: getIt<BasketDataSource>(),
        deleteBasketDataSource: getIt<DeleteBasketDataSource>(),
      ),
    );
    getIt.registerLazySingleton<AddToBasketBloc>(
          () => AddToBasketBloc(addToBasketDataSource: getIt<AddToBasketDataSource>()),
    );
  }
}
