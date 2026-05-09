import 'package:equatable/equatable.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductDetails extends ProductDetailsEvent {
  final int productId;
  final String customerPhone;
  final int customerId;

  const FetchProductDetails({
    required this.productId,
    required this.customerPhone,
    required this.customerId,
  });

  @override
  List<Object?> get props => [productId, customerPhone, customerId];
}