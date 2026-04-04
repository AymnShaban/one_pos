part of '../../new_invoice_imports.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddItemToCart extends CartEvent {
  final CartItemModel item;
  const AddItemToCart(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveItemFromCart extends CartEvent {
  final int productId;
  const RemoveItemFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateItemQuantity extends CartEvent {
  final int productId;
  final num quantity;
  const UpdateItemQuantity({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateItemPrice extends CartEvent {
  final int index;
  final double newPrice;
  const UpdateItemPrice({required this.index, required this.newPrice});

  @override
  List<Object?> get props => [index, newPrice];
}

class UpdateItemDiscount extends CartEvent {
  final int index;
  final num discount;
  const UpdateItemDiscount({required this.index, required this.discount});

  @override
  List<Object?> get props => [index, discount];
}

class UpdateItemNote extends CartEvent {
  final int index;
  final String note;
  const UpdateItemNote({required this.index, required this.note});

  @override
  List<Object?> get props => [index, note];
}

class UpdateExpireDate extends CartEvent {
  final int productId;
  final QtyExpireDateModel expireDate;
  const UpdateExpireDate({required this.productId, required this.expireDate});

  @override
  List<Object?> get props => [productId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class AddPayReceipt extends CartEvent {
  final PayReceiptModel receipt;
  const AddPayReceipt(this.receipt);

  @override
  List<Object?> get props => [receipt];
}

class RemovePayReceipt extends CartEvent {
  final int index;
  const RemovePayReceipt(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateDiscountPercent extends CartEvent {
  final double percent;
  const UpdateDiscountPercent(this.percent);

  @override
  List<Object?> get props => [percent];
}

class UpdateAdditionPercent extends CartEvent {
  final double percent;
  const UpdateAdditionPercent(this.percent);

  @override
  List<Object?> get props => [percent];
}