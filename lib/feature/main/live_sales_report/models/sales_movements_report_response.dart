part of '../live_sales_report_imports.dart';

/// Maps `POST /api/SalMov1Reports` response. Every numeric / count
/// field comes back as a pre-formatted string — render verbatim.
class SalesMovementsReportResponse extends Equatable {
  final List<SalesMovementsReportPage> pages;

  const SalesMovementsReportResponse({this.pages = const []});

  factory SalesMovementsReportResponse.fromJson(Map<String, dynamic> json) {
    return SalesMovementsReportResponse(
      pages: (json['pages'] as List?)
              ?.whereType<Map>()
              .map((e) => SalesMovementsReportPage.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [pages];
}

class SalesMovementsReportPage extends Equatable {
  final String cardHeaderText;
  final String cardFooterText;
  final String lblQty;
  final String lblVal;
  final String paymentMethods;
  final String sumProfit;
  final String sumFinalValue;
  final String sumBliCost;
  final String sumProfitRatio;
  final String sumQty;
  final String sumBliCostRatio;
  final List<SalesMovementsReportRow> rows;

  const SalesMovementsReportPage({
    this.cardHeaderText = '',
    this.cardFooterText = '',
    this.lblQty = '',
    this.lblVal = '',
    this.paymentMethods = '',
    this.sumProfit = '',
    this.sumFinalValue = '',
    this.sumBliCost = '',
    this.sumProfitRatio = '',
    this.sumQty = '',
    this.sumBliCostRatio = '',
    this.rows = const [],
  });

  factory SalesMovementsReportPage.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => (v ?? '').toString();
    return SalesMovementsReportPage(
      cardHeaderText: s(json['cardHeaderText']),
      cardFooterText: s(json['cardFooterText']),
      lblQty: s(json['lblQty']),
      lblVal: s(json['lblVal']),
      paymentMethods: s(json['lstr_PaymentMethods']),
      sumProfit: s(json['sumProfit']),
      sumFinalValue: s(json['sumFinalValue']),
      sumBliCost: s(json['sumBliCost']),
      sumProfitRatio: s(json['sumProfitRatio']),
      sumQty: s(json['sumQty']),
      sumBliCostRatio: s(json['sumBliCostRatio']),
      rows: (json['salMov1ReportResultDtos'] as List?)
              ?.whereType<Map>()
              .map((e) => SalesMovementsReportRow.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [
        cardHeaderText,
        cardFooterText,
        lblQty,
        lblVal,
        paymentMethods,
        sumProfit,
        sumFinalValue,
        sumBliCost,
        sumProfitRatio,
        sumQty,
        sumBliCostRatio,
        rows,
      ];
}

class SalesMovementsReportRow extends Equatable {
  final String blNo;
  final String qty;
  final String finalValue;

  const SalesMovementsReportRow({
    this.blNo = '',
    this.qty = '',
    this.finalValue = '',
  });

  factory SalesMovementsReportRow.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => (v ?? '').toString();
    return SalesMovementsReportRow(
      blNo: s(json['blNo']),
      qty: s(json['qty']),
      finalValue: s(json['finalValue']),
    );
  }

  @override
  List<Object?> get props => [blNo, qty, finalValue];
}
