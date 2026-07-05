part of '../live_sales_report_imports.dart';

/// Maps `GET /api/EtMovement/delegates`. Response is a raw array of
/// `{ "empId": "1", "empName": "Amer 1 1" }` — `empId` arrives as a
/// numeric string.
class DelegateModel extends Equatable {
  final int empId;
  final String empName;

  const DelegateModel({required this.empId, required this.empName});

  factory DelegateModel.fromJson(Map<String, dynamic> json) {
    return DelegateModel(
      empId: int.tryParse(json['empId'].toString()) ?? 0,
      empName: json['empName'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [empId];
}
