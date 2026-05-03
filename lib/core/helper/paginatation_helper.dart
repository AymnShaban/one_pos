import '../services/service_locator/services_imports.dart';
import 'helper.dart';

class PaginationHandler<T, B extends BlocBase<BaseState<T>>> {
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int pageSize;
  List<T> items = [];
  final B bloc;
  final String? cacheKey;

  PaginationHandler({required this.bloc, this.cacheKey, this.pageSize = 15});

  final _cache = getIt<IPaginatedCache<T>>();

  Future<void> loadFirstPage(
    PaginateFunc<T> fetchFunction, {
    Map<String, dynamic>? params,
    String? cacheKey,
  }) async {
    if (bloc.state.isLoading) return;
    bloc.emit(bloc.state.copyWith(status: Status.loading, items: []));
    items.clear();
    currentPage = 1;
    isLoadingMore = false;
    hasMoreData = true;

    final result = await fetchFunction(currentPage, pageSize, params);
    await result.fold(
      (failure) async {
        if (cacheKey != null) {
          final cached = await _cache.getCachedPage(cacheKey: cacheKey);
          if (cached.isNotEmpty) {
            items = cached;
            bloc.emit(
              bloc.state.copyWith(
                status: Status.success,
                items: List<T>.from(items),
              ),
            );
            return;
          }
        }
        bloc.emit(
          bloc.state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (data) async {
        items.addAll(data);
        if (cacheKey != null) {
          await _cache.cachePage(
            items,
            cacheKey: cacheKey,
          ); // Cache the first page
        }
        if (data.length >= pageSize) {
          currentPage++;
        } else {
          hasMoreData = false;
        }
        bloc.emit(
          bloc.state.copyWith(
            status: Status.success,
            items: List<T>.from(items),
          ),
        );
      },
    );
  }

  Future<void> fetchData(
    PaginateFunc<T> fetchFunction, {
    Map<String, dynamic>? params,
  }) async {
    if (!hasMoreData || isLoadingMore) {
      logger(
        'Not loading more - hasMoreData: $hasMoreData, isLoadingMore: $isLoadingMore',
      );
      return;
    }

    isLoadingMore = true;
    if (currentPage > 1) {
      bloc.emit(bloc.state.copyWith(status: Status.isLoadingMore));
    }

    final result = await fetchFunction(
      currentPage,
      pageSize,
      params?..removeWhere((key, value) => value == null || value == ''),
    );
    await result.fold(
      (failure) async {
        isLoadingMore = false;
        bloc.emit(
          bloc.state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (data) async {
        items.addAll(data);
        if (data.length >= pageSize) {
          currentPage++;
          loggerFatal('Loaded more data, currentPage: $currentPage');
        } else {
          hasMoreData = false;
          loggerFatal('No more data to load');
        }
        isLoadingMore = false;
        bloc.emit(
          bloc.state.copyWith(
            status: Status.success,
            items: List<T>.from(items),
          ),
        );
      },
    );
  }
}

typedef PaginateFunc<T> =
    Future<Either<Failure, List<T>>> Function(
      int page,
      int limit, [
      Map<String, dynamic>? params,
    ]);
