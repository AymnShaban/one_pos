
import '../../invoice_profit_imports.dart';

class InvoiceProfitResponseModel extends Equatable {
  final double totalSum;
  final double costSum;
  final double benifitSum;
  final double finalSum;
  final double freeCostSum;      // ➕ جديد
  final double discSum;          // ➕ جديد
  final double extraSum;         // ➕ جديد
  final double netValueSum;      // ➕ جديد
  final double prepaidSum;       // ➕ جديد
  final double remainderSum;     // ➕ جديد
  final double weightSum;        // ➕ جديد
  final String totalCostRatio;   // ➕ جديد
  final String totalBenifitRatio; // ➕ جديد
  final String totalDiscRatio;   // ➕ جديد
  final String totalExtraRatio;  // ➕ جديد
  final String totalFinalRatio;  // ➕ جديد
  final String startDate;        // ➕ جديد
  final String endDate;          // ➕ جديد
  final String mode;             // ➕ جديد
  final List<InvoiceProfitItem> rows;

  const InvoiceProfitResponseModel({
    required this.totalSum,
    required this.costSum,
    required this.benifitSum,
    required this.finalSum,
    required this.freeCostSum,
    required this.discSum,
    required this.extraSum,
    required this.netValueSum,
    required this.prepaidSum,
    required this.remainderSum,
    required this.weightSum,
    required this.totalCostRatio,
    required this.totalBenifitRatio,
    required this.totalDiscRatio,
    required this.totalExtraRatio,
    required this.totalFinalRatio,
    required this.startDate,
    required this.endDate,
    required this.mode,
    required this.rows,
  });

  factory InvoiceProfitResponseModel.fromJson(Map<String, dynamic> json) {
    final rowsList = json['rows'] as List? ?? [];
    return InvoiceProfitResponseModel(
      totalSum: (json['totalSum'] ?? 0).toDouble(),
      costSum: (json['costSum'] ?? 0).toDouble(),
      benifitSum: (json['benifitSum'] ?? 0).toDouble(),
      finalSum: (json['finalSum'] ?? 0).toDouble(),
      freeCostSum: (json['freeCostSum'] ?? 0).toDouble(),
      discSum: (json['discSum'] ?? 0).toDouble(),
      extraSum: (json['extraSum'] ?? 0).toDouble(),
      netValueSum: (json['netValueSum'] ?? 0).toDouble(),
      prepaidSum: (json['prepaidSum'] ?? 0).toDouble(),
      remainderSum: (json['remainderSum'] ?? 0).toDouble(),
      weightSum: (json['weightSum'] ?? 0).toDouble(),
      totalCostRatio: json['totalCostRatio'] ?? '0',
      totalBenifitRatio: json['totalBenifitRatio'] ?? '0',
      totalDiscRatio: json['totalDiscRatio'] ?? '0',
      totalExtraRatio: json['totalExtraRatio'] ?? '0',
      totalFinalRatio: json['totalFinalRatio'] ?? '0',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      mode: json['mode'] ?? '',
      rows: rowsList.map((item) => InvoiceProfitItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSum': totalSum,
      'costSum': costSum,
      'benifitSum': benifitSum,
      'finalSum': finalSum,
      'freeCostSum': freeCostSum,
      'discSum': discSum,
      'extraSum': extraSum,
      'netValueSum': netValueSum,
      'prepaidSum': prepaidSum,
      'remainderSum': remainderSum,
      'weightSum': weightSum,
      'totalCostRatio': totalCostRatio,
      'totalBenifitRatio': totalBenifitRatio,
      'totalDiscRatio': totalDiscRatio,
      'totalExtraRatio': totalExtraRatio,
      'totalFinalRatio': totalFinalRatio,
      'startDate': startDate,
      'endDate': endDate,
      'mode': mode,
      'rows': rows.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    totalSum,
    costSum,
    benifitSum,
    finalSum,
    freeCostSum,
    discSum,
    extraSum,
    netValueSum,
    prepaidSum,
    remainderSum,
    weightSum,
    totalCostRatio,
    totalBenifitRatio,
    totalDiscRatio,
    totalExtraRatio,
    totalFinalRatio,
    startDate,
    endDate,
    mode,
    rows,
  ];
}

class InvoiceProfitItem extends Equatable {
  final int blNo;                // ➕ جديد
  final String blDate;           // ➕ جديد
  final String dateDisplay;
  final String billType;
  final String billName;         // ➕ جديد
  final int supposeType;         // ➕ جديد
  final int id;                  // ➕ جديد
  final String acName;
  final String acEName;
  final String acCode;
  final int custId;              // ➕ جديد
  final double total;
  final double cost;
  final double freeCost;         // ➕ جديد
  final double benifit;
  final double disc;
  final double extra;
  final double netValue;
  final double finalProfit;
  final String costPercentage;
  final String netProfitsPercentage;
  final String costProfitsPercentage;
  final double prepaid;
  final double remainder;
  final double totalWeight;
  final String brName;           // ➕ جديد
  final String freeTypeName;     // ➕ جديد
  final String remainderColor;   // ➕ جديد
  final bool isReturn;
  final bool isSalesmanHeader;   // ➕ جديد
  final String salesmanName;     // ➕ جديد
  final int empId;               // ➕ جديد
  final double salesmanTotal;    // ➕ جديد
  final double salesmanCost;     // ➕ جديد
  final double salesmanBenifit;  // ➕ جديد
  final double salesmanFinal;    // ➕ جديد

  const InvoiceProfitItem({
    required this.blNo,
    required this.blDate,
    required this.dateDisplay,
    required this.billType,
    required this.billName,
    required this.supposeType,
    required this.id,
    required this.acName,
    required this.acEName,
    required this.acCode,
    required this.custId,
    required this.total,
    required this.cost,
    required this.freeCost,
    required this.benifit,
    required this.disc,
    required this.extra,
    required this.netValue,
    required this.finalProfit,
    required this.costPercentage,
    required this.netProfitsPercentage,
    required this.costProfitsPercentage,
    required this.prepaid,
    required this.remainder,
    required this.totalWeight,
    required this.brName,
    required this.freeTypeName,
    required this.remainderColor,
    required this.isReturn,
    required this.isSalesmanHeader,
    required this.salesmanName,
    required this.empId,
    required this.salesmanTotal,
    required this.salesmanCost,
    required this.salesmanBenifit,
    required this.salesmanFinal,
  });

  factory InvoiceProfitItem.fromJson(Map<String, dynamic> json) {
    return InvoiceProfitItem(
      blNo: json['blNo'] ?? 0,
      blDate: json['blDate'] ?? '',
      dateDisplay: json['dateDisplay'] ?? '',
      billType: json['billType'] ?? '',
      billName: json['billName'] ?? '',
      supposeType: json['supposeType'] ?? 0,
      id: json['id'] ?? 0,
      acName: json['acName'] ?? '',
      acEName: json['acEName'] ?? '',
      acCode: json['acCode'] ?? '',
      custId: json['custId'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      cost: (json['cost'] ?? 0).toDouble(),
      freeCost: (json['freeCost'] ?? 0).toDouble(),
      benifit: (json['benifit'] ?? 0).toDouble(),
      disc: (json['disc'] ?? 0).toDouble(),
      extra: (json['extra'] ?? 0).toDouble(),
      netValue: (json['netValue'] ?? 0).toDouble(),
      finalProfit: (json['final'] ?? 0).toDouble(),
      costPercentage: json['costPercentage'] ?? '0%',
      netProfitsPercentage: json['netProfitsPercentage'] ?? '0%',
      costProfitsPercentage: json['costProfitsPercentage'] ?? '0%',
      prepaid: (json['prepaid'] ?? 0).toDouble(),
      remainder: (json['remainder'] ?? 0).toDouble(),
      totalWeight: (json['totalWeight'] ?? 0).toDouble(),
      brName: json['brName'] ?? '',
      freeTypeName: json['freeTypeName'] ?? '',
      remainderColor: json['remainderColor'] ?? '',
      isReturn: json['isReturn'] ?? false,
      isSalesmanHeader: json['isSalesmanHeader'] ?? false,
      salesmanName: json['salesmanName'] ?? '',
      empId: json['empId'] ?? 0,
      salesmanTotal: (json['salesmanTotal'] ?? 0).toDouble(),
      salesmanCost: (json['salesmanCost'] ?? 0).toDouble(),
      salesmanBenifit: (json['salesmanBenifit'] ?? 0).toDouble(),
      salesmanFinal: (json['salesmanFinal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blNo': blNo,
      'blDate': blDate,
      'dateDisplay': dateDisplay,
      'billType': billType,
      'billName': billName,
      'supposeType': supposeType,
      'id': id,
      'acName': acName,
      'acEName': acEName,
      'acCode': acCode,
      'custId': custId,
      'total': total,
      'cost': cost,
      'freeCost': freeCost,
      'benifit': benifit,
      'disc': disc,
      'extra': extra,
      'netValue': netValue,
      'final': finalProfit,
      'costPercentage': costPercentage,
      'netProfitsPercentage': netProfitsPercentage,
      'costProfitsPercentage': costProfitsPercentage,
      'prepaid': prepaid,
      'remainder': remainder,
      'totalWeight': totalWeight,
      'brName': brName,
      'freeTypeName': freeTypeName,
      'remainderColor': remainderColor,
      'isReturn': isReturn,
      'isSalesmanHeader': isSalesmanHeader,
      'salesmanName': salesmanName,
      'empId': empId,
      'salesmanTotal': salesmanTotal,
      'salesmanCost': salesmanCost,
      'salesmanBenifit': salesmanBenifit,
      'salesmanFinal': salesmanFinal,
    };
  }

  @override
  List<Object?> get props => [
    blNo,
    blDate,
    dateDisplay,
    billType,
    billName,
    supposeType,
    id,
    acName,
    acEName,
    acCode,
    custId,
    total,
    cost,
    freeCost,
    benifit,
    disc,
    extra,
    netValue,
    finalProfit,
    costPercentage,
    netProfitsPercentage,
    costProfitsPercentage,
    prepaid,
    remainder,
    totalWeight,
    brName,
    freeTypeName,
    remainderColor,
    isReturn,
    isSalesmanHeader,
    salesmanName,
    empId,
    salesmanTotal,
    salesmanCost,
    salesmanBenifit,
    salesmanFinal,
  ];
}