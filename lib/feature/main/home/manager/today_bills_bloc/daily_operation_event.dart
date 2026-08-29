

import '../../../main_reports/expense_analysis/expense_analysis_imports.dart';

abstract class DailyOperationsEvent extends Equatable {
  const DailyOperationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyOperations extends DailyOperationsEvent {
  const LoadDailyOperations();
}

class RefreshDailyOperations extends DailyOperationsEvent {
  const RefreshDailyOperations();
}

class ClearDailyOperations extends DailyOperationsEvent {
  const ClearDailyOperations();
}