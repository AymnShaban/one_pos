import 'package:equatable/equatable.dart';

enum InvoiceStatus { all, completed, pending, cancelled }

extension InvoiceStatusExtension on InvoiceStatus {
  String get arLabel {
    switch (this) {
      case InvoiceStatus.all:       return 'الكل';
      case InvoiceStatus.completed: return 'مكتمل';
      case InvoiceStatus.pending:   return 'معلق';
      case InvoiceStatus.cancelled: return 'ملغي';
    }
  }

  String get apiValue {
    switch (this) {
      case InvoiceStatus.all:       return '';
      case InvoiceStatus.completed: return 'completed';
      case InvoiceStatus.pending:   return 'pending';
      case InvoiceStatus.cancelled: return 'cancelled';
    }
  }
}

class InvoiceModel extends Equatable {
  final String invoiceId;
  final String invoiceNumber;
  final String customerName;
  final DateTime dateTime;
  final double totalAmount;
  final double? remainingAmount;
  final int productCount;
  final InvoiceStatus status;

  const InvoiceModel({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.customerName,
    required this.dateTime,
    required this.totalAmount,
    this.remainingAmount,
    required this.productCount,
    required this.status,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceId: json['InvoiceId']?.toString() ?? '',
      invoiceNumber: json['InvoiceNumber'] ?? '',
      customerName: json['CustomerName'] ?? '',
      dateTime: DateTime.tryParse(json['InvoiceDate'] ?? '') ?? DateTime.now(),
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      remainingAmount: json['RemainingAmount'] != null
          ? (json['RemainingAmount']).toDouble()
          : null,
      productCount: json['ProductCount'] ?? 0,
      status: _parseStatus(json['Status']),
    );
  }

  static InvoiceStatus _parseStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'completed': return InvoiceStatus.completed;
      case 'pending':   return InvoiceStatus.pending;
      case 'cancelled': return InvoiceStatus.cancelled;
      default:          return InvoiceStatus.completed;
    }
  }

  Map<String, dynamic> toJson() => {
    'InvoiceId':       invoiceId,
    'InvoiceNumber':   invoiceNumber,
    'CustomerName':    customerName,
    'InvoiceDate':     dateTime.toIso8601String(),
    'TotalAmount':     totalAmount,
    'RemainingAmount': remainingAmount,
    'ProductCount':    productCount,
    'Status':          status.apiValue,
  };

  @override
  List<Object?> get props => [
    invoiceId, invoiceNumber, customerName,
    dateTime, totalAmount, remainingAmount,
    productCount, status,
  ];
}

class InvoiceStatsModel extends Equatable {
  final int total;
  final int completed;
  final int pending;

  const InvoiceStatsModel({
    this.total = 0,
    this.completed = 0,
    this.pending = 0,
  });

  factory InvoiceStatsModel.fromList(List<InvoiceModel> invoices) {
    return InvoiceStatsModel(
      total:     invoices.length,
      completed: invoices.where((i) => i.status == InvoiceStatus.completed).length,
      pending:   invoices.where((i) => i.status == InvoiceStatus.pending).length,
    );
  }

  @override
  List<Object?> get props => [total, completed, pending];
}