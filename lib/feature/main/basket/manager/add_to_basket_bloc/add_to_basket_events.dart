part of '../../basket_imports.dart';

abstract class AddToBasketEvent extends BasketEvent{}
class AddToBasket extends AddToBasketEvent  {
  final AddToBasketRequest request;

  AddToBasket(this.request);
}