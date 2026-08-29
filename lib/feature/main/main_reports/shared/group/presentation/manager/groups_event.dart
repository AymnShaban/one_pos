import '../../../shared_imports.dart';
abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroups extends GroupsEvent {
  const LoadGroups();
}

class ClearGroups extends GroupsEvent {
  const ClearGroups();
}