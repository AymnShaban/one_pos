
import '../../../../invoice_profit_imports.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeesDataSource dataSource;

  EmployeesBloc({required this.dataSource}) : super(const EmployeesState()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<SelectEmployee>(_onSelectEmployee);
  }

  Future<void> _onLoadEmployees(
      LoadEmployees event,
      Emitter<EmployeesState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getEmployees(searchText: event.searchText);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (employees) {
        // ✅ أول مندوب
        // final firstId = employees.isNotEmpty ? employees.first.empId : null;
        //
        // // ✅ كل الـ IDs
        // final allIds = employees.map((e) => e.empId).toSet();

        emit(
          state.copyWith(
            status: Status.success,
            employees: employees,

            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectEmployee(
      SelectEmployee event,
      Emitter<EmployeesState> emit,
      ) {
    final employeeId = event.employeeId;

    // ✅ نتأكد إن المندوب موجود
    final exists = state.employees.any((e) => e.empId == employeeId);

    if (exists) {
      emit(
        state.copyWith(
          selectedEmployeeId: employeeId,
          selectedEmployeeIds: {employeeId},
        ),
      );
    }
  }
}