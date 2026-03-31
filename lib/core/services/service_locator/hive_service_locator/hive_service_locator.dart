import 'package:get_it/get_it.dart';

import '../../../local/hive_service_impl.dart';
import '../../../models/item_model.dart';

class HiveServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<HiveServiceImpl>(
      () => HiveServiceImpl.instance,
    );
    getIt.registerLazySingleton<IUserCache>(() => HiveServiceImpl.instance);
    getIt.registerLazySingleton<IPaginatedCache<ItemModel>>(() => ProductPaginatedCache<ItemModel>(HiveServiceImpl.instance));
  }
}
