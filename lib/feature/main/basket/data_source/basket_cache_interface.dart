part of '../basket_imports.dart';

abstract interface class IBasket {
  Future<void> saveBasketItem(ItemModel item);

  /// Sets the basket line for [item] to exactly [quantity] in one operation
  /// (no per-unit looping). A quantity <= 0 removes the line.
  Future<void> setBasketItemQuantity(ItemModel item, int quantity);

  Future<List<ItemModel>> getBasketItems();
  Future<void> deleteBasketItem(int productId, String barCode);

  /// Replaces the stored line for [item] (matched by product + barcode) with
  /// the given snapshot — used for inline edits of quantity / price / discount.
  Future<void> updateBasketItem(ItemModel item);
  Future<void> clearBasket();
}
