class PostEntryRequestModel {
  final int voucherType;
  final int voucherNumber;
  final String creationDateTime;
  final int cashAcId;
  final double voucherValue;
  final int currencyId;
  final double currencyRate;
  final String? cvNumber;
  final bool isPosted;
  final String? checkNumber;
  final String? checkDueDate;
  final String? notes;
  final int employeeId;
  final String? createdBy;
  final String? postedBy;
  final int postNumber;
  final String? receivedFrom;
  final bool isCanceled;
  final int branchId;
  final int entryLevel;
  final bool isFromPaying;
  final int bankAcId;
  final int discountAcId;
  final double discountValue;
  final String? referenceNO;
  final String? entryNature;
  final List<VoucherAccountRequestModel> voucherAccounts;

  PostEntryRequestModel({
    required this.voucherType,
    this.voucherNumber = 0,
    required this.creationDateTime,
    required this.cashAcId,
    required this.voucherValue,
    required this.currencyId,
    required this.currencyRate,
    this.cvNumber,
    this.isPosted = true,
    this.checkNumber,
    this.checkDueDate,
    this.notes,
    this.employeeId = 0,
    this.createdBy,
    this.postedBy,
    this.postNumber = 0,
    this.receivedFrom,
    this.isCanceled = false,
    required this.branchId,
    this.entryLevel = 0,
    this.isFromPaying = false,
    this.bankAcId = 0,
    this.discountAcId = 0,
    this.discountValue = 0,
    this.referenceNO,
    this.entryNature,
    required this.voucherAccounts,
  });

  Map<String, dynamic> toJson() {
    return {
      'voucherType': voucherType,
      'voucherNumber': voucherNumber,
      'creationDateTime': creationDateTime,
      'cashAcId': cashAcId,
      'voucherValue': voucherValue,
      'currencyId': currencyId,
      'currencyRate': currencyRate,
      'cvNumber': cvNumber ?? '',
      'isPosted': isPosted,
      'checkNumber': checkNumber ?? '',
      'checkDueDate': checkDueDate,
      'notes': notes ?? '',
      'employeeId': employeeId,
      'createdBy': createdBy ?? '',
      'postedBy': postedBy ?? '',
      'postNumber': postNumber,
      'receivedFrom': receivedFrom ?? '',
      'isCanceled': isCanceled,
      'branchId': branchId,
      'entryLevel': entryLevel,
      'isFromPaying': isFromPaying,
      'bankAcId': bankAcId,
      'discountAcId': discountAcId,
      'discountValue': discountValue,
      'referenceNO': referenceNO ?? '',
      'entryNature': entryNature ?? '',
      'voucherAccounts': voucherAccounts.map((e) => e.toJson()).toList(),

    };
  }
}

class VoucherAccountRequestModel {
  final int acId;
  final int number;
  final double debit;
  final double credit;
  final int currencyId;
  final double currencyRate;
  final int costCenterId;
  final String? notes;
  final double equivalent;
  final int itemRowNumber;
  final int acBranchId;
  final double entryRate;
  final double entryEquivalent;
  final String? rowSate;
  final String? notes2;
  final int agreementNo;
  final int keyNet;
  final String? acNameAr;
  final String? acNameEn;
  final String? costCenterNameAr;
  final String? costCenterNameEn;

  VoucherAccountRequestModel({
    required this.acId,
    this.number = 0,
    required this.debit,
    required this.credit,
    required this.currencyId,
    required this.currencyRate,
    this.costCenterId = 0,
    this.notes,
    this.equivalent = 0,
    this.itemRowNumber = 0,
    this.acBranchId = 0,
    this.entryRate = 0,
    this.entryEquivalent = 0,
    this.rowSate,
    this.notes2,
    this.agreementNo = 0,
    this.keyNet = 0,
    this.acNameAr,
    this.acNameEn,
    this.costCenterNameAr,
    this.costCenterNameEn,
  });

  Map<String, dynamic> toJson() {
    return {
      'acId': acId,
      'number': number,
      'debit': debit,
      'credit': credit,
      'currencyId': currencyId,
      'currencyRate': currencyRate,
      'costCenterId': costCenterId,
      'notes': notes ?? '',
      'equivalent': equivalent,
      'itemRowNumber': itemRowNumber,
      'acBranchId': acBranchId,
      'entryRate': entryRate,
      'entryEquivalent': entryEquivalent,
      'rowSate': rowSate ?? '',
      'notes2': notes2 ?? '',
      'agreementNo': agreementNo,
      'keyNet': keyNet,
      'acNameAr': acNameAr ?? '',
      'acNameEn': acNameEn ?? '',
      'costCenterNameAr': costCenterNameAr ?? '',
      'costCenterNameEn': costCenterNameEn ?? '',
    };
  }
}