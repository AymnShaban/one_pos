/// فاتورة واحدة في تقرير "أرباح الفواتير" (بدون تفصيل أصناف — انظر
/// item_profit.dart للتقرير الآخر الذي يفصّل كل صنف داخل الفاتورة).
class InvoiceProfit {
  final String number;
  final String client;
  final String date;
  final String description;
  final double total;
  final double cost;
  final double profit;
  final double discount;
  final double additions;
  final double netValue;
  final double netProfit;
  final double pctSale; // نسبة الربح/البيع%
  final double pctCost; // نسبة الربح/التكلفة%
  final double pct; // نسبة الربح%

  InvoiceProfit({
    required this.number,
    required this.client,
    required this.date,
    required this.description,
    required this.total,
    required this.cost,
    required this.profit,
    required this.discount,
    required this.additions,
    required this.netValue,
    required this.netProfit,
    required this.pctSale,
    required this.pctCost,
    required this.pct,
  });

  bool get isLoss => profit < 0;
}
