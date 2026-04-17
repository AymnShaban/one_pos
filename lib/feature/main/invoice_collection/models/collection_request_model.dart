part of '../invoice_collection_imports.dart';

class CollectionRequestModel {
  final int branchId;
  final String creationDateTime;
  final int codePw;
  final int currencyId;
  final double currencyRate;
  final String voucherValue;
  final String checkNumber;
  final String checkDueDate;
  final String notes;
  final int voucherType;
  final num invoiceId;
  final num invoiceNo;
  final num acId;
  final num agreementNo;
  final num keyNet;

  // Only for edit
  final num? voucherNumber;

  const CollectionRequestModel({
    required this.branchId,
    required this.creationDateTime,
    required this.codePw,
    required this.currencyId,
    required this.currencyRate,
    required this.voucherValue,
    required this.checkNumber,
    required this.checkDueDate,
    required this.notes,
    required this.voucherType,
    required this.invoiceId,
    required this.invoiceNo,
    required this.acId,
    required this.agreementNo,
    required this.keyNet,
    this.voucherNumber,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'BranchId':         branchId,
      'CreationDateTime': creationDateTime,
      'Code_PW':          codePw,
      'CurrencyId':       currencyId,
      'CurrencyRate':     currencyRate,
      'VoucherValue':     voucherValue,
      'CheckNumber':      checkNumber,
      'CheckDueDate':     checkDueDate,
      'Notes':            notes,
      'VoucherType':      voucherType,
      'InvoiceID':        invoiceId,
      'InvoiceNo':        invoiceNo,
      'VoucherAccounts': [
        {
          'AcId':        acId,
          'AgreementNo': agreementNo,
          'KeyNet':      keyNet,
        }
      ],
    };
    if (voucherNumber != null) {
      map['VoucherNumber'] = voucherNumber;
    }
    return map;
  }
}