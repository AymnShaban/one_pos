part of '../../home_imports.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class InitHome extends HomeEvent {
  const InitHome();
}

class ToggleSyncMode extends HomeEvent {
  const ToggleSyncMode();
}

class CheckConnectivity extends HomeEvent {
  const CheckConnectivity();
}