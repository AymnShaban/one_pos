part of '../../live_sales_report_imports.dart';

abstract class DelegateEvent extends Equatable {
  const DelegateEvent();

  @override
  List<Object?> get props => [];
}

/// Fire from the report screen's `initState`. Idempotent — same guard as
/// `LoadBranches`.
class LoadDelegates extends DelegateEvent {
  const LoadDelegates();
}
