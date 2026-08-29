
import '../../expense_analysis_imports.dart';

class ExpenseAccountModel extends Equatable {
  final int id;
  final String name;
  final String code;

  const ExpenseAccountModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ExpenseAccountModel.fromJson(Map<String, dynamic> json) {
    return ExpenseAccountModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }

  @override
  List<Object?> get props => [id, name, code];
}