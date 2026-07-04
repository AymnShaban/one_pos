part of '../new_invoice_imports.dart';

class PayReceiptModel extends Equatable {
  final double payingValue;
  final num payingType;
  final String receiptNumber;
  final String payWayName;
  final String payWayEnName;

  const PayReceiptModel({
    required this.payingValue,
    required this.payingType,
    this.receiptNumber = '-',
    required this.payWayName,
    required this.payWayEnName,
  });

  Map<String, dynamic> toJson() => {
    'payingValue':  payingValue,
    'payingType':   payingType,
    'referenceNo':  receiptNumber,
    'payWayName':   payWayName,
    'payWayEnName': payWayEnName,
  };

  @override
  List<Object?> get props => [payingValue, payingType, receiptNumber];
}