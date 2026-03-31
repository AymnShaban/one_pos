import 'package:equatable/equatable.dart';

abstract class AreasEvent extends Equatable {
  const AreasEvent();

  @override
  List<Object> get props => [];
}

class GetAreasEvent extends AreasEvent {}

class GetAreasByGovernorateIdEvent extends AreasEvent {
  final int governorateId;

  const GetAreasByGovernorateIdEvent({required this.governorateId});

  @override
  List<Object> get props => [governorateId];
}