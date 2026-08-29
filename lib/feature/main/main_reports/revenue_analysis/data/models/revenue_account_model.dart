

import '../../revenue_analysis_import.dart';
class RevenueAccountModel extends Equatable {
  final int id;
  final String name;
  final String code;

  const RevenueAccountModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory RevenueAccountModel.fromJson(Map<String, dynamic> json) {
    return RevenueAccountModel(
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