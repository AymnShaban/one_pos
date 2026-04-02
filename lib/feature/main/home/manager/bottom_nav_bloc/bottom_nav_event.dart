import 'package:equatable/equatable.dart';

abstract class NavEvent extends Equatable {
  const NavEvent();

  @override
  List<Object?> get props => [];
}

class ChangeNavTab extends NavEvent {
  final int index;

  const ChangeNavTab(this.index);

  @override
  List<Object?> get props => [index];
}