
String formatNumber(double value, {int decimals = 2, bool trailingMinus = false}) {
  final isNegative = value < 0;
  final absValue = value.abs().toStringAsFixed(decimals);
  final parts = absValue.split('.');
  final withCommas = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
  final formatted = decimals > 0 ? '$withCommas.${parts[1]}' : withCommas;
  if (!isNegative) return formatted;
  return trailingMinus ? '$formatted-' : '-$formatted';
}


String formatPercent(double value, {int decimals = 3}) {
  return '${value.toStringAsFixed(decimals)}%';
}
