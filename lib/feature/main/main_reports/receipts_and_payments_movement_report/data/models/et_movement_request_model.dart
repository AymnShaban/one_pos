import '../../receipts_and_payments_movement_report_import.dart';
class EtMovementReportRequestModel extends Equatable {
  final EtMovementRequest request;
  final List<EtMovementSelectedEntry> selectedEntries;

  const EtMovementReportRequestModel({
    required this.request,
    required this.selectedEntries,
  });

  Map<String, dynamic> toJson() {
    return {
      'request': request.toJson(),
      'selectedEntries': selectedEntries.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [request, selectedEntries];
}

class EtMovementRequest extends Equatable {
  final String startDate;
  final String endDate;
  final bool orderByCode;
  final bool isArabic;
  final String? costCenter;
  final int? employeeId;
  final String? companyBranch;
  final bool showPosted;
  final bool showNotPosted;
  final bool showEntryNet;
  final bool? checksFilter;
  final String? accountFilter;
  final String? receivedFrom;
  final String? deliveredTo;
  final bool employeeAccordingToCustomer;
  final double currencyRate;

  const EtMovementRequest({
    required this.startDate,
    required this.endDate,
    required this.orderByCode,
    required this.isArabic,
    this.costCenter,
    this.employeeId,
    this.companyBranch,
    this.showPosted = true,
    this.showNotPosted = true,
    this.showEntryNet = true,
    this.checksFilter,
    this.accountFilter,
    this.receivedFrom,
    this.deliveredTo,
    this.employeeAccordingToCustomer = true,
    this.currencyRate = 1.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'orderByCode': orderByCode,
      'isArabic': isArabic,
      'costCenter': costCenter,
      'employeeId': employeeId,
      'companyBranch': companyBranch,
      'showPosted': showPosted,
      'showNotPosted': showNotPosted,
      'showEntryNet': showEntryNet,
      'checksFilter': checksFilter,
      'accountFilter': accountFilter,
      'receivedFrom': receivedFrom,
      'deliveredTo': deliveredTo,
      'employeeAccordingToCustomer': employeeAccordingToCustomer,
      'currencyRate': currencyRate,
    };
  }

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    orderByCode,
    isArabic,
    costCenter,
    employeeId,
    companyBranch,
    showPosted,
    showNotPosted,
    showEntryNet,
    checksFilter,
    accountFilter,
    receivedFrom,
    deliveredTo,
    employeeAccordingToCustomer,
    currencyRate,
  ];
}

class EtMovementSelectedEntry extends Equatable {
  final int id;
  final bool status;


  const EtMovementSelectedEntry({
    required this.id,
    required this.status,

  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,

    };
  }

  @override
  List<Object?> get props => [id, status];
}