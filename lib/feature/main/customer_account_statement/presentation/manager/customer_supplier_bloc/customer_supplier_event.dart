import '../../../customer_account_imports.dart';

abstract class CustomerAccountEvent extends Equatable {
  const CustomerAccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerSuppliers extends CustomerAccountEvent {
  const LoadCustomerSuppliers();
}
