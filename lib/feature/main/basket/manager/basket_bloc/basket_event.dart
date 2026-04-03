part of '../../basket_imports.dart';

abstract class BasketEvent extends Equatable {
const BasketEvent();
@override
List<Object?> get props => [];
}

class FetchBasketItems extends BasketEvent {
const FetchBasketItems();
@override
List<Object?> get props => [];
}

class   UpdateQuantity extends BasketEvent {
final int productId;
final int newQuantity;
final String barCode;

const UpdateQuantity(this.productId, this.newQuantity,this.barCode);
@override
List<Object?> get props => [productId, newQuantity,barCode];
}

class DeleteBasketItem extends BasketEvent {
final int productId;
final String productBarcode;



const DeleteBasketItem(this.productId,this.productBarcode);
@override
List<Object?> get props => [productId,productBarcode];
}
class ClearBasket extends BasketEvent {
  const ClearBasket();

  @override
  List<Object?> get props => [];
}
