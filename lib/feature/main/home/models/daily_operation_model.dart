import 'package:equatable/equatable.dart';
class DailyOperationModel extends Equatable {
  final String blDate;
  final int blNo;
  final String finalValue;
  final int id;
  final String patternEnName;
  final String patternName;

  const DailyOperationModel({
    required this.blDate,
    required this.blNo,
    required this.finalValue,
    required this.id,
    required this.patternEnName,
    required this.patternName,
  });

  factory DailyOperationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DailyOperationModel(
      blDate: json['blDate'] ?? '',
      blNo: json['blNo'] ?? 0,
      finalValue: json['finalValue'] ?? '0',
      id: json['id'] ?? 0,
      patternEnName: json['patternEnName'] ?? '',
      patternName: json['patternName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blDate': blDate,
      'blNo': blNo,
      'finalValue': finalValue,
      'id': id,
      'patternEnName': patternEnName,
      'patternName': patternName,
    };
  }

  @override
  List<Object?> get props => [
    blDate,
    blNo,
    finalValue,
    id,
    patternEnName,
    patternName,
  ];
}