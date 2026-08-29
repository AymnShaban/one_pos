
import '../../../shared_imports.dart';

abstract class StoresEvent extends Equatable {
  const StoresEvent();

  @override
  List<Object?> get props => [];
}

class LoadStores extends StoresEvent {
  const LoadStores();
}

class ClearStores extends StoresEvent {
  const ClearStores();
}