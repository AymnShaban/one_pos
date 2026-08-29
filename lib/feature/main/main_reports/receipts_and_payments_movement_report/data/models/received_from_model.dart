import '../../receipts_and_payments_movement_report_import.dart';

class ReceivedFromModel extends Equatable {
  final String name;

  const ReceivedFromModel({
    required this.name,
  });

  factory ReceivedFromModel.fromJson(Map<String, dynamic> json) {
    return ReceivedFromModel(
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