import '../../../../invoice_profit_imports.dart';

abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeesEvent {
  final String? searchText;

  const LoadEmployees({this.searchText});

  @override
  List<Object?> get props => [searchText];
}

class SelectEmployee extends EmployeesEvent {
  final String employeeId;

  const SelectEmployee({required this.employeeId});

  @override
  List<Object?> get props => [employeeId];
}