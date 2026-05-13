
import 'package:easy_localization/easy_localization.dart';

import '../../feature/main/basket/basket_imports.dart';
// import '../../feature/main/favourite/favorite_imports.dart';
import '../helper/helper.dart';
import '../services/service_locator/services_imports.dart';
import 'custom_snack_bar.dart';

class ProductListWrapper extends StatefulWidget {
  final Widget child;

  const ProductListWrapper({super.key, required this.child});

  @override
  State<ProductListWrapper> createState() => _ProductListWrapperState();
}

class _ProductListWrapperState extends State<ProductListWrapper> {
  // Simple debouncing mechanism: track last SnackBar time per product
  final Map<int, DateTime> _lastSnackBarTime = {};
  static const _debounceDuration = Duration(seconds: 2);

  bool _shouldShowSnackBar(int productId) {
    final now = DateTime.now();
    final lastTime = _lastSnackBarTime[productId];
    if (lastTime == null || now.difference(lastTime) > _debounceDuration) {
      _lastSnackBarTime[productId] = now;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider.value(value: getIt<FavoriteBloc>()),
        BlocProvider.value(value: getIt<AddToBasketBloc>()),
        BlocProvider.value(value: getIt<BasketBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddToBasketBloc, BaseState<void>>(
            listener: (context, state) {
              if (state.status == Status.success &&
                  state.metadata['action'] == 'add') {

                showCustomSnackBar(context, 'added_to_cart'.tr());
                getIt<BasketBloc>().add(const FetchBasketItems());
              }
            },
          ),
          BlocListener<BasketBloc, BaseState<BasketItemModel>>(
            listener: (context, state) {
              if (state.status == Status.success &&
                  state.metadata['action'] == 'add') {
                showCustomSnackBar(context, 'added_to_cart'.tr());
                getIt<BasketBloc>().add(const FetchBasketItems());
              }
            },
          ),
        ],
        child: widget.child,
      ),
    );
  }
}
