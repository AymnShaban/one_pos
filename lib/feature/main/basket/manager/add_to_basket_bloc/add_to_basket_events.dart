
import '../../models/add_to_basket_model.dart';
import '../basket_bloc/basket_event.dart';

abstract class AddToBasketEvent extends BasketEvent{}
class AddToBasket extends AddToBasketEvent  {
  final AddToBasketRequest request;

  AddToBasket(this.request);
}