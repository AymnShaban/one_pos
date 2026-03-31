extension IntParser on String {
  int toInt() {
    return int.tryParse(this)??0;
  }
  double toDouble() {
    return double.tryParse(this)??0.0;
  }
}