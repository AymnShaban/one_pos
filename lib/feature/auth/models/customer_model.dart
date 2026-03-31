import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 0)
class CustomerModel extends Equatable {
  @HiveField(0)
  final int customerId;
  @HiveField(1)
  final String? arabicName;
  @HiveField(2)
  final String? englishName;
  @HiveField(3)
  final String? customerPhone;
  @HiveField(4)
  final String? lastName;
  @HiveField(5)
  final String password;
  @HiveField(6)
  final String email;
  @HiveField(7)
  final int regionId;
  @HiveField(8)
  final String? regionName;
  @HiveField(9)
  final int placeId;
  @HiveField(10)
  final String? districtName;
  @HiveField(11)
  final String? streetName;
  @HiveField(12)
  final String? gada;
  @HiveField(13)
  final String? houseNo;
  @HiveField(14)
  final String? block;
  @HiveField(15)
  final String? floor;
  @HiveField(16)
  final String? apartment;
  @HiveField(17)
  final String? addressNotes;
  @HiveField(18)
  final String? customerAddress;
  @HiveField(19)
  final double? billValue;
  @HiveField(20)
  final String? paymentMethod;
  @HiveField(21)
  final double? deliveryValue;
  @HiveField(22)
  final String? districtName2;
  @HiveField(23)
  final String? districtEName2;
  @HiveField(24)
  final String? token;
  @HiveField(25)
  final String? mapCustomerAddress;
  @HiveField(26)
  final String? mapPlaceId;
  @HiveField(27)
  final String addressId;
  @HiveField(28)
  final String? customerLastName;

  const CustomerModel({
    required this.customerId,
    this.arabicName,
    this.englishName,
    this.customerPhone,
    this.lastName,
    required this.password,
    required this.email,
    required this.regionId,
    this.regionName,
    required this.placeId,
    this.districtName,
    this.streetName,
    this.gada,
    this.houseNo,
    this.block,
    this.floor,
    this.apartment,
    this.addressNotes,
    this.customerAddress,
    this.billValue,
    this.paymentMethod,
    this.deliveryValue,
    this.districtName2,
    this.districtEName2,
    this.token,
    this.mapCustomerAddress,
    this.mapPlaceId,
    required this.addressId,
    this.customerLastName,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final customerId = json['CustomerID'] as int? ?? 0;
    final password = json['PassWord'] as String? ?? "";
    final email = json['Email'] as String? ?? "";
    final regionId = json['region_id'] as int? ?? 0;
    final placeId = json['place_id'] as int? ?? 0;
    final addressId = json['AddressID'] as String? ?? "";

    return CustomerModel(
      customerId: customerId,
      arabicName: json['ArabicName'] ?? "",
      englishName: json['EnglishName'] ?? "",
      customerPhone: json['CustomerPhone'] ?? "",
      lastName: json['LastName'] ?? "",
      password: password,
      email: email,
      regionId: regionId,
      regionName: json['RegionName'] ?? "",
      placeId: placeId,
      districtName: json['DistrictName'] ?? "",
      streetName: json['StreetName'] ?? "",
      gada: json['Gada'] ?? "",
      houseNo: json['HouseNo'] ?? "",
      block: json['Block'] ?? "",
      floor: json['Floor'] ?? "",
      apartment: json['Apartment'] ?? "",
      addressNotes: json['AddressNotes'] ?? "",
      customerAddress: json['CustomerAddress'] ?? "",
      billValue: double.tryParse(json['BillValue']?.toString() ?? ''),
      paymentMethod: json['PaymentMethod'] ?? "",
      deliveryValue: double.tryParse(json['DeliveryValue']?.toString() ?? ''),
      districtName2: json['DistrictName2'] ?? "",
      districtEName2: json['DistrictEName2'] ?? "",
      token: json['Token'] ?? "",
      mapCustomerAddress: json['MapCustomerAddress'] ?? "",
      mapPlaceId: json['MapPlaceID'] ?? "",
      addressId: addressId,
      customerLastName: json['CustomerLastName'] ?? "",
    );
  }

  @override
  List<Object?> get props => [
    customerId,
    arabicName,
    englishName,
    customerPhone,
    lastName,
    password,
    email,
    regionId,
    regionName,
    placeId,
    districtName,
    streetName,
    gada,
    houseNo,
    block,
    floor,
    apartment,
    addressNotes,
    customerAddress,
    billValue,
    paymentMethod,
    deliveryValue,
    districtName2,
    districtEName2,
    token,
    mapCustomerAddress,
    mapPlaceId,
    addressId,
    customerLastName,
  ];

  Map<String, dynamic> toJson() {
    return {
      'CustomerID': customerId,
      'ArabicName': arabicName,
      'EnglishName': englishName,
      'CustomerPhone': customerPhone,
      'LastName': lastName,
      'PassWord': password,
      'Email': email,
      'RegionID': regionId,
      'RegionName': regionName,
      'PlaceID': placeId,
      'DistrictName': districtName,
      'StreetName': streetName,
      'Gada': gada,
      'HouseNo': houseNo,
      'Block': block,
      'Floor': floor,
      'Apartment': apartment,
      'AddressNotes': addressNotes,
      'CustomerAddress': customerAddress,
      'BillValue': billValue,
      'PaymentMethod': paymentMethod,
      'DeliveryValue': deliveryValue,
      'DistrictName2': districtName2,
      'DistrictEName2': districtEName2,
      'Token': token,
      'MapCustomerAddress': mapCustomerAddress,
      'MapPlaceID': mapPlaceId,
      'AddressID': addressId,
      'CustomerLastName': customerLastName,
    };
  }

  CustomerModel copyWith({
    int? customerId,
    String? arabicName,
    String? englishName,
    String? customerPhone,
    String? lastName,
    String? password,
    String? email,
    int? regionId,
    String? regionName,
    int? placeId,
    String? districtName,
    String? streetName,
    String? gada,
    String? houseNo,
    String? block,
    String? floor,
    String? apartment,
    String? addressNotes,
    String? customerAddress,
    double? billValue,
    String? paymentMethod,
    double? deliveryValue,
    String? districtName2,
    String? districtEName2,
    String? token,
    String? mapCustomerAddress,
    String? mapPlaceId,
    String? addressId,
    String? customerLastName,
  }) {
    return CustomerModel(
      customerId: customerId ?? this.customerId,
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      customerPhone: customerPhone ?? this.customerPhone,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      email: email ?? this.email,
      regionId: regionId ?? this.regionId,
      regionName: regionName ?? this.regionName,
      placeId: placeId ?? this.placeId,
      districtName: districtName ?? this.districtName,
      streetName: streetName ?? this.streetName,
      gada: gada ?? this.gada,
      houseNo: houseNo ?? this.houseNo,
      block: block ?? this.block,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      addressNotes: addressNotes ?? this.addressNotes,
      customerAddress: customerAddress ?? this.customerAddress,
      billValue: billValue ?? this.billValue,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryValue: deliveryValue ?? this.deliveryValue,
      districtName2: districtName2 ?? this.districtName2,
      districtEName2: districtEName2 ?? this.districtEName2,
      token: token ?? this.token,
      mapCustomerAddress: mapCustomerAddress ?? this.mapCustomerAddress,
      mapPlaceId: mapPlaceId ?? this.mapPlaceId,
      addressId: addressId ?? this.addressId,
      customerLastName: customerLastName ?? this.customerLastName,
    );
  }
  @override
  String toString() {
    return 'CustomerModel(${toJson()})';
  }
}
