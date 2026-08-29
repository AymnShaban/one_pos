import '../../../customer_account_imports.dart';

class CustomerSupplierBloc extends Bloc<CustomerAccountEvent, BaseState<List<CustomerSupplierModel>>> {
  final CustomerSupplierDataSource dataSource;

  CustomerSupplierBloc({required this.dataSource})
      : super(const BaseState<List<CustomerSupplierModel>>()) {
    on<LoadCustomerSuppliers>(_onLoadCustomerSuppliers);
  }

  Future<void> _onLoadCustomerSuppliers(
      LoadCustomerSuppliers event,
      Emitter<BaseState<List<CustomerSupplierModel>>> emit,
      ) async {
    emit(state.copyWith(
      status: Status.loading,
      errorMessage: null,
      data: null,
    ));

    final result = await dataSource.getCustomerSuppliers();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (customers) => emit(
        state.copyWith(
          status: Status.success,
          data: customers,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }
}
