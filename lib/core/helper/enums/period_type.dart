enum PeriodType {
  monthly,
  period,
  quarterly,
}

extension PeriodTypeExtension on PeriodType {
  String get coType {
    switch (this) {
      case PeriodType.monthly:
        return 'Monthly';
      case PeriodType.period:
        return 'Period';
      case PeriodType.quarterly:
        return 'Quarterly';
    }
  }

  int get coEType {
    switch (this) {
      case PeriodType.monthly:
        return 1;
      case PeriodType.period:
        return 2;
      case PeriodType.quarterly:
        return 3;
    }
  }
}