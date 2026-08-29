
import '../../../../invoice_profit_imports.dart';


class CustomersState extends Equatable {
  final Status status;
  final List<CustomerModel> customers;
  final int? selectedCustomerId;
  final String? errorMessage;

  const CustomersState({
    this.status = Status.initial,
    this.customers = const [],
    this.selectedCustomerId,
    this.errorMessage,
  });

  CustomerModel? get selectedCustomer {
    if (selectedCustomerId == null) return null;
    try {
      return customers.firstWhere(
            (customer) => customer.acID == selectedCustomerId,
      );
    } catch (e) {
      return null;
    }
  }

  CustomersState copyWith({
    Status? status,
    List<CustomerModel>? customers,
    int? selectedCustomerId,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return CustomersState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      selectedCustomerId: clearSelected
          ? null
          : (selectedCustomerId ?? this.selectedCustomerId),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    customers,
    selectedCustomerId,
    errorMessage,
  ];
}