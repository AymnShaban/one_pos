import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'areas_model.g.dart';

@HiveType(typeId: 4) // Choose a unique typeId
class AreasModel extends Equatable {
  @HiveField(0)
  final int districtID;

  @HiveField(1)
  final int governorateID;

  @HiveField(2)
  final num deliveryValue;

  @HiveField(3)
  final String districtName;

  @HiveField(4)
  final String districtEName;

  @HiveField(5)
  final num billValue;

  @HiveField(6)
  final String paymentMethod;

  const AreasModel({
    required this.districtID,
    required this.governorateID,
    required this.deliveryValue,
    required this.districtName,
    required this.districtEName,
    required this.billValue,
    required this.paymentMethod,
  });

  factory AreasModel.fromJson(Map<String, dynamic> json) => AreasModel(
    districtID: json['DistrictID'] ?? 0,
    governorateID: json['GovernorateID'] ?? 0,
    deliveryValue: json['DeliveryValue'] ?? 0,
    districtName: json['DistrictName'] ?? "",
    districtEName: json['DistrictEName'] ?? "",
    billValue: json['BillValue'] ?? 0,
    paymentMethod: json['PaymentMethod']?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    'DistrictID': districtID,
    'GovernorateID': governorateID,
    'DeliveryValue': deliveryValue,
    'DistrictName': districtName,
    'DistrictEName': districtEName,
    'BillValue': billValue,
    'PaymentMethod': paymentMethod,
  };

  @override
  List<Object?> get props => [
    districtID,
    governorateID,
    deliveryValue,
    districtName,
    districtEName,
    billValue,
    paymentMethod,
  ];
}