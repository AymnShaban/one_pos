part of '../basket_imports.dart';

class AddToBasketRequest extends Equatable {
  final int customerID;
  final int productID;
  final String productBarcode;

  const AddToBasketRequest({
    required this.customerID,
    required this.productID,
    required this.productBarcode,
  });

  Map<String, dynamic> toJson() {
    return {
      'CustomerID': customerID,
      'ProductID': productID,
      "BarCode":productBarcode
    };
  }

  @override
  List<Object?> get props => [customerID, productID,productBarcode];
}
class AddToBasketResponse extends Equatable {
  final bool success;
  final String? message;

  const AddToBasketResponse({
    required this.success,
    this.message,
  });

  factory AddToBasketResponse.fromJson(Map<String, dynamic> json) {
    return AddToBasketResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [success, message];
}