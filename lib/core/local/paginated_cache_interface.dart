part of "hive_service_impl.dart";

abstract interface class IPaginatedCache<T> {
  Future<void> cachePage(List<T> items, {String? cacheKey});
  Future<List<T>> getCachedPage({String? cacheKey});
  Future<void> clearSavedKeys();
}

class ProductPaginatedCache<ItemModel> implements IPaginatedCache<ItemModel> {
  final HiveServiceImpl _hiveService;
  const ProductPaginatedCache(this._hiveService);
  @override
  Future<void> cachePage(List<ItemModel> items, {String? cacheKey}) {
    return _hiveService._cachePage<ItemModel>(items, cacheKey: cacheKey);
  }

  @override
  Future<void> clearSavedKeys() {
    return _hiveService.clearUserModel();
  }

  @override
  Future<List<ItemModel>> getCachedPage({String? cacheKey}) {
    return _hiveService._getCachedPage<ItemModel>(cacheKey: cacheKey);
  }
}
