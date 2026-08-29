
import '../../../expense_analysis/expense_analysis_imports.dart';

class EmployeeModel extends Equatable {
  final String empId;
  final String empName;

  const EmployeeModel({
    required this.empId,
    required this.empName,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      empId: json['empId']?.toString() ?? '',
      empName: json['empName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empId': empId,
      'empName': empName,
    };
  }

  @override
  List<Object?> get props => [empId, empName];
}