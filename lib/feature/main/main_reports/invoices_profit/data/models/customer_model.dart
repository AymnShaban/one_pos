
import '../../invoice_profit_imports.dart';

class CustomerModel extends Equatable {
  final int acID;
  final String acCode;
  final String acName;
  final String acEName;

  const CustomerModel({
    required this.acID,
    required this.acCode,
    required this.acName,
    required this.acEName,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      acID: json['acID'] ?? 0,
      acCode: json['acCode']?.toString() ?? '',
      acName: json['acName'] ?? '',
      acEName: json['acEName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acID': acID,
      'acCode': acCode,
      'acName': acName,
      'acEName': acEName,
    };
  }

  @override
  List<Object?> get props => [acID, acCode, acName, acEName];
}