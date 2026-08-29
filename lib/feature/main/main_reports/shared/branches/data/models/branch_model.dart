
import '../../branches_import.dart';
class BranchModel extends Equatable {
  final int id;
  final String braCode;
  final String braName;
  final String braEName;
  final String braTel;
  final String braAddress;
  final bool deactivated;

  const BranchModel({
    required this.id,
    required this.braCode,
    required this.braName,
    required this.braEName,
    required this.braTel,
    required this.braAddress,
    required this.deactivated,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] ?? 0,
      braCode: json['braCode']?.toString() ?? '',
      braName: json['braName'] ?? '',
      braEName: json['braEName'] ?? '',
      braTel: json['braTel'] ?? '',
      braAddress: json['braAddress'] ?? '',
      deactivated: json['deactivated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'braCode': braCode,
      'braName': braName,
      'braEName': braEName,
      'braTel': braTel,
      'braAddress': braAddress,
      'deactivated': deactivated,
    };
  }

  @override
  List<Object?> get props => [
    id,
    braCode,
    braName,
    braEName,
    braTel,
    braAddress,
    deactivated,
  ];
}