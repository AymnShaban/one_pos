
class ProfitItemModel {
  final String name;
  final int soldQuantity;
  final double cost;
  final double sales;

  const ProfitItemModel({
    required this.name,
    required this.soldQuantity,
    required this.cost,
    required this.sales,
  });

  double get profit => sales - cost;

  double get marginPercent => sales == 0 ? 0 : (profit / sales) * 100;
}
