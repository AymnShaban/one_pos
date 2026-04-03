part of "hive_service_impl.dart";

abstract interface class IPaginatedCache<T> {
  Future<void> cachePage(List<T> items, {String? cacheKey});
  Future<List<T>> getCachedPage({String? cacheKey});
  Future<void> clearSavedKeys();
}

class GenericPaginatedCache<T> implements IPaginatedCache<T> {
  final HiveServiceImpl _hiveService;
  const GenericPaginatedCache(this._hiveService);
  @override
  Future<void> cachePage(List<T> items, {String? cacheKey}) {
    return _hiveService._cachePage<T>(items, cacheKey: cacheKey);
  }

  @override
  Future<void> clearSavedKeys() {
    return _hiveService.clearUserModel();
  }

  @override
  Future<List<T>> getCachedPage({String? cacheKey}) {
    return _hiveService._getCachedPage<T>(cacheKey: cacheKey);
  }
}
