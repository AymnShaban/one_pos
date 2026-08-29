
import '../../../../invoice_profit_imports.dart';

class EmployeesState extends Equatable {
  final Status status;
  final List<EmployeeModel> employees;
  final Set<String> selectedEmployeeIds;
  final String? selectedEmployeeId;
  final String? errorMessage;

  const EmployeesState({
    this.status = Status.initial,
    this.employees = const [],
    this.selectedEmployeeIds = const {},
    this.selectedEmployeeId,
    this.errorMessage,
  });

  bool get hasEmployees => employees.isNotEmpty;

  EmployeeModel? get selectedEmployee {
    if (selectedEmployeeId == null) return null;
    try {
      return employees.firstWhere(
            (employee) => employee.empId == selectedEmployeeId,
      );
    } catch (e) {
      return null;
    }
  }

  EmployeesState copyWith({
    Status? status,
    List<EmployeeModel>? employees,
    Set<String>? selectedEmployeeIds,
    String? selectedEmployeeId,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return EmployeesState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      selectedEmployeeIds: selectedEmployeeIds ?? this.selectedEmployeeIds,
      selectedEmployeeId: clearSelected
          ? null
          : (selectedEmployeeId ?? this.selectedEmployeeId),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    employees,
    selectedEmployeeIds,
    selectedEmployeeId,
    errorMessage,
  ];
}