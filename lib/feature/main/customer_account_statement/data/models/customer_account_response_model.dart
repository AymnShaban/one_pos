class CustomerAccountStatementResponseModel {
  final String? acCode;
  final String? acName;
  final String? acEName;
  final String? aciCodeName;
  final String? txtPhone;
  final String? txtFax;
  final String? txtMail;

  final List<CustomerAccountStatementItemModel>
  customerAccountsReportResultDtos;

  const CustomerAccountStatementResponseModel({
    this.acCode,
    this.acName,
    this.acEName,
    this.aciCodeName,
    this.txtPhone,
    this.txtFax,
    this.txtMail,
    this.customerAccountsReportResultDtos = const [],
  });

  factory CustomerAccountStatementResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CustomerAccountStatementResponseModel(
      acCode: json['acCode']?.toString(),
      acName: json['acName']?.toString(),
      acEName: json['acEName']?.toString(),
      aciCodeName: json['aciCodeName']?.toString(),
      txtPhone: json['txtPhone']?.toString(),
      txtFax: json['txtFax']?.toString(),
      txtMail: json['txtMail']?.toString(),
      customerAccountsReportResultDtos:
      (json['customerAccountsReportResultDtos'] as List?)
          ?.whereType<Map<String, dynamic>>()
          .map(CustomerAccountStatementItemModel.fromJson)
          .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acCode': acCode,
      'acName': acName,
      'acEName': acEName,
      'aciCodeName': aciCodeName,
      'txtPhone': txtPhone,
      'txtFax': txtFax,
      'txtMail': txtMail,
      'customerAccountsReportResultDtos':
      customerAccountsReportResultDtos
          .map((item) => item.toJson())
          .toList(),
    };
  }
}

class CustomerAccountStatementItemModel {
  final String? balance;
  final String? credit;
  final String? debit;
  final String? notes;
  final String? date;
  final String? document;

  final dynamic returnValue;
  final dynamic customerBranch;
  final dynamic account;
  final dynamic billTotalQty;
  final dynamic deputy;
  final dynamic colCheckNo;
  final dynamic colNotes2;
  final dynamic colPayConditions;
  final dynamic colNotes;
  final dynamic id;
  final dynamic billName;
  final dynamic suppType;
  final dynamic debitStyleBackColor;
  final dynamic creditStyleBackColor;
  final dynamic defaultCellStyleBackColor;

  const CustomerAccountStatementItemModel({
    this.balance,
    this.credit,
    this.debit,
    this.notes,
    this.date,
    this.document,
    this.returnValue,
    this.customerBranch,
    this.account,
    this.billTotalQty,
    this.deputy,
    this.colCheckNo,
    this.colNotes2,
    this.colPayConditions,
    this.colNotes,
    this.id,
    this.billName,
    this.suppType,
    this.debitStyleBackColor,
    this.creditStyleBackColor,
    this.defaultCellStyleBackColor,
  });

  factory CustomerAccountStatementItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CustomerAccountStatementItemModel(
      balance: json['balance']?.toString(),
      credit: json['credit']?.toString(),
      debit: json['debit']?.toString(),
      notes: json['notes']?.toString(),
      date: json['date']?.toString(),
      document: json['document']?.toString(),

      returnValue: json['return'],
      customerBranch: json['customerBranch'],
      account: json['account'],
      billTotalQty: json['billTotalQty'],
      deputy: json['deputy'],

      colCheckNo: json['col_CheckNo'],
      colNotes2: json['col_Notes2'],
      colPayConditions: json['col_PayConditions'],
      colNotes: json['col_Notes'],

      id: json['id'],
      billName: json['billName'],
      suppType: json['suppType'],

      debitStyleBackColor: json['debitStyleBackColor'],
      creditStyleBackColor: json['creditStyleBackColor'],
      defaultCellStyleBackColor:
      json['defaultCellStyleBackColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'credit': credit,
      'debit': debit,
      'notes': notes,
      'date': date,
      'document': document,

      'return': returnValue,
      'customerBranch': customerBranch,
      'account': account,
      'billTotalQty': billTotalQty,
      'deputy': deputy,

      'col_CheckNo': colCheckNo,
      'col_Notes2': colNotes2,
      'col_PayConditions': colPayConditions,
      'col_Notes': colNotes,

      'id': id,
      'billName': billName,
      'suppType': suppType,

      'debitStyleBackColor': debitStyleBackColor,
      'creditStyleBackColor': creditStyleBackColor,
      'defaultCellStyleBackColor':
      defaultCellStyleBackColor,
    };
  }
}