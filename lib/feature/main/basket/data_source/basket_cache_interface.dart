part of '../basket_imports.dart';

abstract interface class IBasket {
  Future<void> saveBasketItem(ItemModel item);
  Future<List<ItemModel>> getBasketItems();
  Future<void> deleteBasketItem(int productId, String barCode);
  Future<void> clearBasket();
}
