part of '../favorite_imports.dart';

class AddAndDeleteFavoriteRequest extends Equatable {
  final int productID;
  final String customerPhone;
  final String barCode;

  const AddAndDeleteFavoriteRequest({
    required this.productID,
    required this.customerPhone,
    required this.barCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'ProductID': productID,
      'CustomerPhone': customerPhone,
      'BarCode': barCode,
    };
  }

  @override
  List<Object?> get props => [productID, customerPhone, barCode];
}