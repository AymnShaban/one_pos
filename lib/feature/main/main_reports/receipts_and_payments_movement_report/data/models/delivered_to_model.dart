import '../../receipts_and_payments_movement_report_import.dart';
class DeliveredToModel extends Equatable {
  final String name;

  const DeliveredToModel({
    required this.name,
  });

  factory DeliveredToModel.fromJson(Map<String, dynamic> json) {
    return DeliveredToModel(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  @override
  List<Object?> get props => [name];
}