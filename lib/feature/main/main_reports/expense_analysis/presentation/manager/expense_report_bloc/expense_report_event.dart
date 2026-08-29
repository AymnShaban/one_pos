import '../../../expense_analysis_imports.dart';

abstract class ExpenseReportEvent extends Equatable {
  const ExpenseReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenseReport extends ExpenseReportEvent {
  final ExpenseReportRequestModel request;

  const LoadExpenseReport({required this.request});

  @override
  List<Object?> get props => [request];
}

class ClearExpenseReport extends ExpenseReportEvent {}