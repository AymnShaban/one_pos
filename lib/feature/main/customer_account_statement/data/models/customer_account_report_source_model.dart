import '../../customer_account_imports.dart';
class CustomerAccountReportSourceModel {
  final int value;
  final String text;
  final bool checked;

  const CustomerAccountReportSourceModel({
    required this.value,
    required this.text,
    required this.checked,
  });

  factory CustomerAccountReportSourceModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CustomerAccountReportSourceModel(
      value: json['value'] ?? 0,
      text: json['text'] ?? '',
      checked: json['checked'] ?? false,
    );
  }
}