
import '../../../../invoice_profit_imports.dart';


class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final CustomersDataSource dataSource;

  CustomersBloc({required this.dataSource}) : super(const CustomersState()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<SelectCustomer>(_onSelectCustomer);
  }

  Future<void> _onLoadCustomers(
      LoadCustomers event,
      Emitter<CustomersState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getCustomers(search: event.search);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (customers) {
        // ✅ منغير تحديد قيمة افتراضية
        emit(
          state.copyWith(
            status: Status.success,
            customers: customers,
            // ❌ مش بنحدد selectedCustomerId
            selectedCustomerId: null,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectCustomer(
      SelectCustomer event,
      Emitter<CustomersState> emit,
      ) {
    emit(
      state.copyWith(
        selectedCustomerId: event.customerId,
      ),
    );
  }
}