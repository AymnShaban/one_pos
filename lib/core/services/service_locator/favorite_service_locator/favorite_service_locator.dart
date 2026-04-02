import 'package:get_it/get_it.dart';
import '../../../../../../feature/main/favourite/data_source/favorite_data_source.dart';
import '../../../../../../feature/main/favourite/manager/add_to_favorite_bloc/add_to_favorite_bloc.dart';
import '../../../datasource/generic_data_source.dart';

class FavoriteServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<FavoriteDataSource>(
          () => FavoriteDataSourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerLazySingleton<FavoriteBloc>(
          () => FavoriteBloc(favoriteDataSource: getIt<FavoriteDataSource>()),
    );
  }
}