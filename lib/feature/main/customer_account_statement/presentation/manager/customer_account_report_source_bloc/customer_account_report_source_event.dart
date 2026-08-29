import '../../../customer_account_imports.dart';
abstract class CustomerAccountReportSourceEvent extends Equatable {
  const CustomerAccountReportSourceEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerAccountReportSources
    extends CustomerAccountReportSourceEvent {}

class SelectCustomerAccountReportSource
    extends CustomerAccountReportSourceEvent {
  final int value;

  const SelectCustomerAccountReportSource({
    required this.value,
  });

  @override
  List<Object?> get props => [value];
}

class ClearCustomerAccountReportSources
    extends CustomerAccountReportSourceEvent {}