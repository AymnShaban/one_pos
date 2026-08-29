import '../../receipts_and_payments_movement_report_import.dart';

class EtMovementReportResponseModel extends Equatable {
  final List<EtMovementItem> data;
  final double totalReceipt;
  final double totalPayment;
  final String? message;

  const EtMovementReportResponseModel({
    required this.data,
    required this.totalReceipt,
    required this.totalPayment,
    this.message,
  });

  factory EtMovementReportResponseModel.fromJson(Map<String, dynamic> json) {
    List<EtMovementItem> items = [];
    double totalReceipt = 0;
    double totalPayment = 0;
    String? message = json['message'] as String?;


    if (json['data'] is List) {
      final dataList = json['data'] as List;
      items = dataList.map((e) => EtMovementItem.fromJson(e)).toList();
      totalReceipt = (json['totalReceipt'] ?? 0).toDouble();
      totalPayment = (json['totalPayment'] ?? 0).toDouble();
    }

    else if (json['data'] is Map) {
      final dataMap = json['data'] as Map<String, dynamic>;
      items = (dataMap['data'] as List? ?? [])
          .map((e) => EtMovementItem.fromJson(e))
          .toList();
      totalReceipt = (dataMap['totalReceipt'] ?? 0).toDouble();
      totalPayment = (dataMap['totalPayment'] ?? 0).toDouble();
    }
    // ✅ الحالة 3: البيانات null أو مش موجودة
    else {
      items = [];
      totalReceipt = 0;
      totalPayment = 0;
    }

    return EtMovementReportResponseModel(
      data: items,
      totalReceipt: totalReceipt,
      totalPayment: totalPayment,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'totalReceipt': totalReceipt,
      'totalPayment': totalPayment,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [data, totalReceipt, totalPayment, message];
}

// et_movement_item.dart
class EtMovementItem extends Equatable {
  final DateTime etDate;
  final String etType;
  final String enType;
  final String acName;
  final double balance;
  final String? cv;
  final String? chkNum;
  final DateTime? chkDate;
  final String? empName;
  final int frmNum;
  final int etNumber;
  final String arName;
  final String enName;
  final String? coName;
  final String? coeName;
  final bool isPost;
  final int entryType;
  final int currencyID;
  final double rate;
  final String? receivedFrom;
  final String? deliveredTo;
  final String? notes;

  const EtMovementItem({
    required this.etDate,
    required this.etType,
    required this.enType,
    required this.acName,
    required this.balance,
    this.cv,
    this.chkNum,
    this.chkDate,
    this.empName,
    required this.frmNum,
    required this.etNumber,
    required this.arName,
    required this.enName,
    this.coName,
    this.coeName,
    required this.isPost,
    required this.entryType,
    required this.currencyID,
    required this.rate,
    this.receivedFrom,
    this.deliveredTo,
    this.notes,
  });

  factory EtMovementItem.fromJson(Map<String, dynamic> json) {
    return EtMovementItem(
      etDate: json['etDate'] != null
          ? DateTime.parse(json['etDate'])
          : DateTime.now(),
      etType: json['etType'] ?? '',
      enType: json['enType'] ?? '',
      acName: json['acName'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      cv: json['cv'],
      chkNum: json['chkNum'],
      chkDate: json['chkDate'] != null && json['chkDate']!.isNotEmpty
          ? DateTime.parse(json['chkDate'])
          : null,
      empName: json['empName'],
      frmNum: json['frmNum'] ?? 0,
      etNumber: json['etNumber'] ?? 0,
      arName: json['arName'] ?? '',
      enName: json['enName'] ?? '',
      coName: json['coName'],
      coeName: json['coeName'],
      isPost: json['isPost'] ?? false,
      entryType: json['entryType'] ?? 0,
      currencyID: json['currencyID'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(),
      receivedFrom: json['receivedFrom'],
      deliveredTo: json['deliveredTo'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'etDate': etDate.toIso8601String(),
      'etType': etType,
      'enType': enType,
      'acName': acName,
      'balance': balance,
      'cv': cv,
      'chkNum': chkNum,
      'chkDate': chkDate?.toIso8601String(),
      'empName': empName,
      'frmNum': frmNum,
      'etNumber': etNumber,
      'arName': arName,
      'enName': enName,
      'coName': coName,
      'coeName': coeName,
      'isPost': isPost,
      'entryType': entryType,
      'currencyID': currencyID,
      'rate': rate,
      'receivedFrom': receivedFrom,
      'deliveredTo': deliveredTo,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    etDate,
    etType,
    enType,
    acName,
    balance,
    cv,
    chkNum,
    chkDate,
    empName,
    frmNum,
    etNumber,
    arName,
    enName,
    coName,
    coeName,
    isPost,
    entryType,
    currencyID,
    rate,
    receivedFrom,
    deliveredTo,
    notes,
  ];
}