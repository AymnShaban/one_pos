
import '../../invoice_profit_imports.dart';

class BillSourceModel extends Equatable {
  final int code;
  final String arName;
  final String latinName;

  const BillSourceModel({
    required this.code,
    required this.arName,
    required this.latinName,
  });

  factory BillSourceModel.fromJson(Map<String, dynamic> json) {
    return BillSourceModel(
      code: json['code'] ?? 0,
      arName: json['arName'] ?? '',
      latinName: json['latinName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'arName': arName,
      'latinName': latinName,
    };
  }

  @override
  List<Object?> get props => [code, arName, latinName];
}