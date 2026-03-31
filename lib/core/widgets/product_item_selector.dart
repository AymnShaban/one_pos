// import 'package:collection/collection.dart';
//
// import '../../feature/main/basket/manager/basket_bloc/basket_bloc.dart';
// import '../../feature/main/basket/models/basket_model.dart';
// import '../../feature/main/favourite/manager/add_to_favorite_bloc/add_to_favorite_bloc.dart';
// import '../../feature/main/favourite/models/favorite_model.dart';
// import '../helper/helper.dart';
// import '../models/item_model.dart';
//
// class ProductItemSelector extends StatelessWidget {
//   const ProductItemSelector({
//     super.key,
//     required this.product,
//   });
//
//   final ItemModel product;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<FavoriteBloc, BaseState<FavoriteModel>, bool>(
//       selector: (state) => state.items.any((fav) => fav.productID == product.productId),
//       builder: (context, isFavorite) {
//         return BlocSelector<BasketBloc, BaseState<BasketItemModel>, int?>(
//           selector: (state) {
//             final basketItem = state.items.firstWhereOrNull(
//                   (item) => item.productID == product.productId,
//             );
//             return basketItem?.salesQuantity;
//           },
//           builder: (context, quantity) {
//             return EnhancedProductItem(
//               product: product,
//               initialIsFavorite: isFavorite,
//               initialIsInCart: quantity != null && quantity > 0,
//               initialQuantity: quantity ?? 0,
//             );
//           },
//         );
//       },
//     );
//   }
// }