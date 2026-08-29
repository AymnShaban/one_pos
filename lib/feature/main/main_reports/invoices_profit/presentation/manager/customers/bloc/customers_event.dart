import '../../../../invoice_profit_imports.dart';
abstract class CustomersEvent extends Equatable {
  const CustomersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomersEvent {
  final String? search;

  const LoadCustomers({this.search});

  @override
  List<Object?> get props => [search];
}

class SelectCustomer extends CustomersEvent {
  final int customerId;

  const SelectCustomer({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}