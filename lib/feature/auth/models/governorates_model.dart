import 'package:equatable/equatable.dart';

class GovernoratesModel extends Equatable {
  final int id;
  final String name;
  final String eName;

  const GovernoratesModel({
    required this.id,
    required this.name,
    required this.eName
  });

  factory GovernoratesModel.fromJson(Map<String, dynamic> json) =>
      GovernoratesModel(
        id: json['GovernorateID'] ?? 0,
        name: json['GovernorateName'] ?? "",
        eName: json['GovernorateEName'] ?? "",
      );

  Map<String, dynamic> toJson() => {
    'GovernorateID': id,
    'GovernorateName': name,
  };

  @override
  List<Object?> get props => [id, name];
}
