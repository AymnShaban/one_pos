part of '../invoice_collection_imports.dart';

class VoucherResponseModel extends Equatable {
  final int voucherNumber;
  final int branchId;
  final String creationDateTime;
  final int codePw;
  final int currencyId;
  final double currencyRate;
  final double voucherValue;
  final String checkNumber;
  final String checkDueDate;
  final String notes;
  final int voucherType;
  final int invoiceId;
  final int invoiceNo;
  final int acId;
  final String? acName;
  final String? bankAcName;

  const VoucherResponseModel({
    required this.voucherNumber,
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
    this.acName,
    this.bankAcName,
  });

  factory VoucherResponseModel.fromJson(Map<String, dynamic> json) {
    return VoucherResponseModel(
      voucherNumber:    json['VoucherNumber']    ?? 0,
      branchId:         json['BranchId']         ?? 0,
      creationDateTime: json['CreationDateTime'] ?? '',
      codePw:           json['Code_PW']          ?? 0,
      currencyId:       json['CurrencyId']       ?? 0,
      currencyRate:     (json['CurrencyRate']    ?? 0).toDouble(),
      voucherValue:     (json['VoucherValue']    ?? 0).toDouble(),
      checkNumber:      json['CheckNumber']      ?? '',
      checkDueDate:     json['CheckDueDate']     ?? '',
      notes:            json['Notes']            ?? '',
      voucherType:      json['VoucherType']      ?? 0,
      invoiceId:        json['InvoiceID']        ?? 0,
      invoiceNo:        json['InvoiceNo']        ?? 0,
      acId:             json['AcId']             ?? 0,
      acName:           json['AcName'],
      bankAcName:       json['BankAcName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'VoucherNumber':    voucherNumber,
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
    'AcId':             acId,
    'AcName':           acName,
    'BankAcName':       bankAcName,
  };

  @override
  List<Object?> get props => [voucherNumber, invoiceId];
}