import 'package:equatable/equatable.dart';

abstract class GovernoratesEvent extends Equatable {
  const GovernoratesEvent();

  @override
  List<Object> get props => [];
}

class GetGovernoratesEvent extends GovernoratesEvent {}
