import '../../revenue_analysis_import.dart';
class RevenueReportRequestModel extends Equatable {
  final int mainAcID;
  final DateTime startDate;
  final DateTime endDate;
  final bool showDetailedCostCenter;
  final String coType;
  final int coEType;

  const RevenueReportRequestModel({
    required this.mainAcID,
    required this.startDate,
    required this.endDate,
    this.showDetailedCostCenter = true,
    this.coType = '',
    this.coEType = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'mainAcID': mainAcID,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'showDetailedCostCenter': showDetailedCostCenter,
      'coType': coType,
      'coEType': coEType,
    };
  }

  @override
  List<Object?> get props => [
    mainAcID,
    startDate,
    endDate,
    showDetailedCostCenter,
    coType,
    coEType,
  ];
}