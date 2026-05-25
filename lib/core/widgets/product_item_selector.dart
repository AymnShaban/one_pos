import 'package:collection/collection.dart';
import '../../feature/main/basket/basket_imports.dart';
// import '../../feature/main/favourite/favorite_imports.dart';
import '../helper/helper.dart';
import '../models/item_model.dart';

class ProductItemSelector extends StatelessWidget {
  const ProductItemSelector({
    super.key,
    required this.product,
  });

  final ItemModel product;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BasketBloc, BaseState<ItemModel>, int?>(
      selector: (state) {
        final basketItem = state.items.firstWhereOrNull(
              (item) => item.productId == product.productId,
        );
        // The tile badge / stepper is whole-unit; basket lines may hold a
        // fractional quantity, so round down for the indicator.
        return basketItem?.salesQuantity.toInt();
      },
      builder: (context, quantity) {
        return EnhancedProductItem(
          product: product,
          initialIsFavorite: false,
          initialIsInCart: quantity != null && quantity > 0,
          initialQuantity: quantity ?? 0,
        );
      },
    );

    // return BlocSelector<FavoriteBloc, BaseState<FavoriteModel>, bool>(
    //   selector: (state) => state.items.any((fav) => fav.productID == product.productId),
    //   builder: (context, isFavorite) {
    //   },
    // );
  }
}