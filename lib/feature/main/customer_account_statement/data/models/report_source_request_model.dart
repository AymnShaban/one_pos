import 'package:easy_localization/easy_localization.dart';

class ReportSourceModel {
  final int value;
  final String text;
  final bool checked;

  ReportSourceModel({
    required this.value,
    required this.text,
    required this.checked,
  });

  factory ReportSourceModel.fromJson(Map<String, dynamic> json) {
    return ReportSourceModel(
      value: json['Value'] as int? ?? 0,
      text: json['Text'] as String? ?? '',
      checked: json['Checked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Value': value,
      'Text': text,
      'Checked': checked,
    };
  }
}

// ==================== REQUEST MODEL ====================

class CustomerStatementRequestModel {
  final CustomerStatementRequestData? request;
  final List<ReportSourceModel>? selectedReportSources;

  CustomerStatementRequestModel({
    this.request,
    this.selectedReportSources,
  });

  factory CustomerStatementRequestModel.fromJson(Map<String, dynamic> json) {
    return CustomerStatementRequestModel(
      request: json['Request'] != null
          ? CustomerStatementRequestData.fromJson(json['Request'])
          : null,
      selectedReportSources: json['SelectedReportSources'] != null
          ? (json['SelectedReportSources'] as List)
          .map((e) => ReportSourceModel.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Request': request?.toJson(),
      'SelectedReportSources': selectedReportSources?.map((e) => e.toJson()).toList(),
    };
  }

  factory CustomerStatementRequestModel.create({
    required String fromAccountId,
    required String toAccountId,
    required DateTime fromDate,
    required DateTime toDate,
    String? mainAccountId,
    String? currencyId,
    String? cultureName,
    List<ReportSourceModel>? reportSources,
  }) {
    return CustomerStatementRequestModel(
      request: CustomerStatementRequestData(
        selectedMainAccountDto: mainAccountId ?? '',
        selectedFromAccountDto: fromAccountId,
        selectedToAccountDto: toAccountId,
        selectedCurrencyDto: currencyId ?? '1',
        currencyRate: '1',
        fromDate: DateFormat('yyyy-MM-dd').format(fromDate),
        toDate: DateFormat('yyyy-MM-dd').format(toDate),
        selectedCostCenterDto: '',
        selectedCmbBranchDto: '',
        txtContain: '',
        txtNotContain: '',
        cultureName: cultureName ?? 'ar',
        chkShowPayBillChecked: true,
        chkGeneralChecked: false,
        chkLastConfirmityChecked: false,
        chkCBranchChecked: false,
        chkRefChecked: false,
        chkShowQtyChecked: false,
        chkZeroInvoicesChecked: false,
        chkOrderOperationsAccordingToInputChecked: true,
        chkDisplayBalanceAgesChecked: false,
        chkPreviousBalanceChecked: false,
        chkShowDeputyChecked: false,
        chkShowCheckChecked: false,
        chkShowNotes2Checked: false,
        chkPayConditionChecked: false,
        chkGroupByEntryChecked: false,
        chkShowNotesChecked: false,
        chkPhoneChecked: false,
        checkBox1Checked: false,
        chkFaxChecked: false,
        chkMailChecked: false,
        chkShowbudgetChecked: false,
        chkMultiDbChecked: false,
        chkAllSourcesChecked: false,
      ),
      selectedReportSources: reportSources,
    );
  }
}

// ==================== REQUEST DATA ====================

class CustomerStatementRequestData {
  final String? selectedMainAccountDto;
  final String? selectedFromAccountDto;
  final String? selectedToAccountDto;
  final String? selectedCurrencyDto;
  final String? currencyRate;
  final String? fromDate;
  final String? toDate;
  final String? selectedCostCenterDto;
  final String? selectedCmbBranchDto;
  final String? txtContain;
  final String? txtNotContain;
  final String? cultureName;
  final bool? chkShowPayBillChecked;
  final bool? chkGeneralChecked;
  final bool? chkLastConfirmityChecked;
  final bool? chkCBranchChecked;
  final bool? chkRefChecked;
  final bool? chkShowQtyChecked;
  final bool? chkZeroInvoicesChecked;
  final bool? chkOrderOperationsAccordingToInputChecked;
  final bool? chkDisplayBalanceAgesChecked;
  final bool? chkPreviousBalanceChecked;
  final bool? chkShowDeputyChecked;
  final bool? chkShowCheckChecked;
  final bool? chkShowNotes2Checked;
  final bool? chkPayConditionChecked;
  final bool? chkGroupByEntryChecked;
  final bool? chkShowNotesChecked;
  final bool? chkPhoneChecked;
  final bool? checkBox1Checked;
  final bool? chkFaxChecked;
  final bool? chkMailChecked;
  final bool? chkShowbudgetChecked;
  final bool? chkMultiDbChecked;
  final bool? chkAllSourcesChecked;

  CustomerStatementRequestData({
    this.selectedMainAccountDto,
    this.selectedFromAccountDto,
    this.selectedToAccountDto,
    this.selectedCurrencyDto,
    this.currencyRate,
    this.fromDate,
    this.toDate,
    this.selectedCostCenterDto,
    this.selectedCmbBranchDto,
    this.txtContain,
    this.txtNotContain,
    this.cultureName,
    this.chkShowPayBillChecked,
    this.chkGeneralChecked,
    this.chkLastConfirmityChecked,
    this.chkCBranchChecked,
    this.chkRefChecked,
    this.chkShowQtyChecked,
    this.chkZeroInvoicesChecked,
    this.chkOrderOperationsAccordingToInputChecked,
    this.chkDisplayBalanceAgesChecked,
    this.chkPreviousBalanceChecked,
    this.chkShowDeputyChecked,
    this.chkShowCheckChecked,
    this.chkShowNotes2Checked,
    this.chkPayConditionChecked,
    this.chkGroupByEntryChecked,
    this.chkShowNotesChecked,
    this.chkPhoneChecked,
    this.checkBox1Checked,
    this.chkFaxChecked,
    this.chkMailChecked,
    this.chkShowbudgetChecked,
    this.chkMultiDbChecked,
    this.chkAllSourcesChecked,
  });

  factory CustomerStatementRequestData.fromJson(Map<String, dynamic> json) {
    return CustomerStatementRequestData(
      selectedMainAccountDto: json['SelectedMainAccountDto'] as String?,
      selectedFromAccountDto: json['SelectedFromAccountDto'] as String?,
      selectedToAccountDto: json['SelectedToAccountDto'] as String?,
      selectedCurrencyDto: json['SelectedCurrencyDto'] as String?,
      currencyRate: json['CurrencyRate'] as String?,
      fromDate: json['FromDate'] as String?,
      toDate: json['ToDate'] as String?,
      selectedCostCenterDto: json['SelectedCostCenterDto'] as String?,
      selectedCmbBranchDto: json['SelectedCmbBranchDto'] as String?,
      txtContain: json['TxtContain'] as String?,
      txtNotContain: json['TxtNotContain'] as String?,
      cultureName: json['CultureName'] as String?,
      chkShowPayBillChecked: json['chkShowPayBillChecked'] as bool?,
      chkGeneralChecked: json['chk_GeneralChecked'] as bool?,
      chkLastConfirmityChecked: json['chk_LastConfirmityChecked'] as bool?,
      chkCBranchChecked: json['chk_CBranchChecked'] as bool?,
      chkRefChecked: json['chk_RefChecked'] as bool?,
      chkShowQtyChecked: json['chk_ShowQtyChecked'] as bool?,
      chkZeroInvoicesChecked: json['chk_ZeroInvoicesChecked'] as bool?,
      chkOrderOperationsAccordingToInputChecked: json['chk_OrderOperationsAccordingToInputChecked'] as bool?,
      chkDisplayBalanceAgesChecked: json['chk_DisplayBalanceAgesChecked'] as bool?,
      chkPreviousBalanceChecked: json['chk_PreviousBalanceChecked'] as bool?,
      chkShowDeputyChecked: json['chk_ShowDeputyChecked'] as bool?,
      chkShowCheckChecked: json['chk_ShowCheckChecked'] as bool?,
      chkShowNotes2Checked: json['chk_ShowNotes2Checked'] as bool?,
      chkPayConditionChecked: json['chk_PayConditionChecked'] as bool?,
      chkGroupByEntryChecked: json['chk_GroupByEntryChecked'] as bool?,
      chkShowNotesChecked: json['chk_ShowNotesChecked'] as bool?,
      chkPhoneChecked: json['ChkPhoneChecked'] as bool?,
      checkBox1Checked: json['CheckBox1Checked'] as bool?,
      chkFaxChecked: json['ChkFaxChecked'] as bool?,
      chkMailChecked: json['ChkMailChecked'] as bool?,
      chkShowbudgetChecked: json['chk_ShowbudgetChecked'] as bool?,
      chkMultiDbChecked: json['chk_MultiDbChecked'] as bool?,
      chkAllSourcesChecked: json['chk_AllSourcesChecked'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SelectedMainAccountDto': selectedMainAccountDto ?? '',
      'SelectedFromAccountDto': selectedFromAccountDto ?? '',
      'SelectedToAccountDto': selectedToAccountDto ?? '',
      'SelectedCurrencyDto': selectedCurrencyDto ?? '1',
      'CurrencyRate': currencyRate ?? '1',
      'FromDate': fromDate ?? '',
      'ToDate': toDate ?? '',
      'SelectedCostCenterDto': selectedCostCenterDto ?? '',
      'SelectedCmbBranchDto': selectedCmbBranchDto ?? '',
      'TxtContain': txtContain ?? '',
      'TxtNotContain': txtNotContain ?? '',
      'CultureName': cultureName ?? 'ar',
      'chkShowPayBillChecked': chkShowPayBillChecked ?? true,
      'chk_GeneralChecked': chkGeneralChecked ?? false,
      'chk_LastConfirmityChecked': chkLastConfirmityChecked ?? false,
      'chk_CBranchChecked': chkCBranchChecked ?? false,
      'chk_RefChecked': chkRefChecked ?? false,
      'chk_ShowQtyChecked': chkShowQtyChecked ?? false,
      'chk_ZeroInvoicesChecked': chkZeroInvoicesChecked ?? false,
      'chk_OrderOperationsAccordingToInputChecked': chkOrderOperationsAccordingToInputChecked ?? true,
      'chk_DisplayBalanceAgesChecked': chkDisplayBalanceAgesChecked ?? false,
      'chk_PreviousBalanceChecked': chkPreviousBalanceChecked ?? false,
      'chk_ShowDeputyChecked': chkShowDeputyChecked ?? false,
      'chk_ShowCheckChecked': chkShowCheckChecked ?? false,
      'chk_ShowNotes2Checked': chkShowNotes2Checked ?? false,
      'chk_PayConditionChecked': chkPayConditionChecked ?? false,
      'chk_GroupByEntryChecked': chkGroupByEntryChecked ?? false,
      'chk_ShowNotesChecked': chkShowNotesChecked ?? false,
      'ChkPhoneChecked': chkPhoneChecked ?? false,
      'CheckBox1Checked': checkBox1Checked ?? false,
      'ChkFaxChecked': chkFaxChecked ?? false,
      'ChkMailChecked': chkMailChecked ?? false,
      'chk_ShowbudgetChecked': chkShowbudgetChecked ?? false,
      'chk_MultiDbChecked': chkMultiDbChecked ?? false,
      'chk_AllSourcesChecked': chkAllSourcesChecked ?? false,
    };
  }
}

// ==================== RESPONSE MODEL ====================

class CustomerStatementResponseModel {
  final String? acCode;
  final String? acName;
  final String? acEName;
  final String? aciCodeName;
  final String? txtPhone;
  final String? txtFax;
  final String? txtMail;
  final List<CustomerAccountStatementItemModel>? customerAccountsReportResultDtos;

  CustomerStatementResponseModel({
    this.acCode,
    this.acName,
    this.acEName,
    this.aciCodeName,
    this.txtPhone,
    this.txtFax,
    this.txtMail,
    this.customerAccountsReportResultDtos,
  });

  factory CustomerStatementResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerStatementResponseModel(
      acCode: json['acCode'] as String?,
      acName: json['acName'] as String?,
      acEName: json['acEName'] as String?,
      aciCodeName: json['aciCodeName'] as String?,
      txtPhone: json['txtPhone'] as String?,
      txtFax: json['txtFax'] as String?,
      txtMail: json['txtMail'] as String?,
      customerAccountsReportResultDtos: json['customerAccountsReportResultDtos'] != null
          ? (json['customerAccountsReportResultDtos'] as List)
          .map((e) => CustomerAccountStatementItemModel.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acCode': acCode ?? '',
      'acName': acName ?? '',
      'acEName': acEName ?? '',
      'aciCodeName': aciCodeName ?? '',
      'txtPhone': txtPhone ?? '',
      'txtFax': txtFax ?? '',
      'txtMail': txtMail ?? '',
      'customerAccountsReportResultDtos': customerAccountsReportResultDtos?.map((e) => e.toJson()).toList(),
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

  CustomerAccountStatementItemModel({
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

  factory CustomerAccountStatementItemModel.fromJson(Map<String, dynamic> json) {
    return CustomerAccountStatementItemModel(
      balance: json['balance'] as String?,
      credit: json['credit'] as String?,
      debit: json['debit'] as String?,
      notes: json['notes'] as String?,
      date: json['date'] as String?,
      document: json['document'] as String?,
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
      defaultCellStyleBackColor: json['defaultCellStyleBackColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance ?? '',
      'credit': credit ?? '',
      'debit': debit ?? '',
      'notes': notes ?? '',
      'date': date ?? '',
      'document': document ?? '',
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
      'defaultCellStyleBackColor': defaultCellStyleBackColor,
    };
  }
}