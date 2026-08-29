import '../../../shared_imports.dart';
class GroupsBloc extends Bloc<GroupsEvent, BaseState<List<GroupModel>>> {
  final GroupsDataSource dataSource;

  GroupsBloc({required this.dataSource})
      : super(const BaseState<List<GroupModel>>()) {
    on<LoadGroups>(_onLoadGroups);
    on<ClearGroups>(_onClearGroups);
  }

  Future<void> _onLoadGroups(
      LoadGroups event,
      Emitter<BaseState<List<GroupModel>>> emit,
      ) async {
    emit(state.copyWith(
      status: Status.loading,
      errorMessage: null,
      data: null,
    ));

    final result = await dataSource.getGroups();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (groups) => emit(
        state.copyWith(
          status: Status.success,
          data: groups,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }

  void _onClearGroups(
      ClearGroups event,
      Emitter<BaseState<List<GroupModel>>> emit,
      ) {
    emit(const BaseState<List<GroupModel>>());
  }
}