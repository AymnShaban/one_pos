part of '../new_invoice_imports.dart';

class CreateInvoiceRequest extends Equatable {
  final num invoicePatternId;
  final String invoiceDate;
  final int companyBranchId;
  final num remainder;
  final num currencyId;
  final num currencyRate;
  final int? customerId;
  final double totalValue;
  final num totalAddition;
  final num totalDiscount;
  final double finalValue;
  final num payingType;
  final List<CartItemModel> items;
  final List<PayReceiptModel> payWays;
  final String address;
  final String createdBy;
  final num prePaid;
  final double latitude;
  final double longitude;

  const CreateInvoiceRequest({
    required this.invoicePatternId,
    required this.invoiceDate,
    required this.companyBranchId,
    required this.remainder,
    required this.currencyId,
    required this.currencyRate,
    this.customerId,
    required this.totalValue,
    this.totalAddition = 0,
    this.totalDiscount = 0,
    required this.finalValue,
    required this.payingType,
    required this.items,
    required this.payWays,
    this.address = '',
    this.createdBy = '',
    this.prePaid = 0,
    this.latitude = 0,
    this.longitude = 0,
  });

  Map<String, dynamic> toJson() => {
    'invoiceID':          invoicePatternId,
    'invoiceDate':        invoiceDate,
    'companyBranchID':    companyBranchId,
    'remainder':          remainder,
    'prePaid':            prePaid,
    'currencyID':         currencyId,
    'rate':               currencyRate,
    'customerID':         customerId,
    'totalValue':         totalValue,
    'totalAddition':      totalAddition,
    'totalDiscount':      totalDiscount,
    'finalValue':         finalValue,
    'payingType':         payingType,
    'salesInvoiceItems':  items.map((e) => e.toInvoiceJson()).toList(),
    'salesInvoicePayWays': payWays.map((e) => e.toJson()).toList(),
    'address':            address,
    'createdBy':          createdBy,
    'latitude':           latitude,
    'longitude':          longitude,
  };

  @override
  List<Object?> get props => [invoicePatternId, invoiceDate, companyBranchId];
}

class EditInvoiceRequest extends Equatable {
  final int invoiceId;
  final String invoiceNo;
  final String invoiceDate;
  final int companyBranchId;
  final num payingType;
  final num remainder;
  final num currencyId;
  final num currencyRate;
  final int? customerId;
  final double totalValue;
  final num totalAddition;
  final num totalDiscount;
  final double finalValue;
  final List<CartItemModel> items;
  final List<PayReceiptModel> payWays;
  final String createdBy;
  final num prePaid;

  const EditInvoiceRequest({
    required this.invoiceId,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.companyBranchId,
    required this.payingType,
    required this.remainder,
    required this.currencyId,
    required this.currencyRate,
    this.customerId,
    required this.totalValue,
    this.totalAddition = 0,
    this.totalDiscount = 0,
    required this.finalValue,
    required this.items,
    required this.payWays,
    this.createdBy = '',
    this.prePaid   = 0,
  });

  Map<String, dynamic> toJson() => {
    'InvoiceID':          invoiceId,
    'InvoiceNo':          invoiceNo,
    'InvoiceDate':        invoiceDate,
    'CompanyBranchID':    companyBranchId,
    'PayingType':         payingType,
    'Remainder':          remainder,
    'CurrencyID':         currencyId,
    'PrePaid':            prePaid,
    'Rate':               currencyRate,
    'CustomerID':         customerId,
    'TotalValue':         totalValue,
    'TotalAddition':      totalAddition,
    'TotalDiscount':      totalDiscount,
    'Createdby':          createdBy,
    'notes':              '',
    'FinalValue':         finalValue,
    'SalesInvoiceItems':  items.map((e) => e.toInvoiceJson()).toList(),
    'SalesInvoicePayWays': payWays.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [invoiceId, invoiceNo];
}