
import '../../../../invoice_profit_imports.dart';


import '../../../../invoice_profit_imports.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersDataSource dataSource;

  UsersBloc({required this.dataSource}) : super(const UsersState()) {
    on<LoadUsers>(_onLoadUsers);
    on<SelectUser>(_onSelectUser);
  }

  Future<void> _onLoadUsers(
      LoadUsers event,
      Emitter<UsersState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getUsers();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (users) {

        emit(
          state.copyWith(
            status: Status.success,
            users: users,
            selectedUserName: null, // ✅ أول مستخدم
            selectedUserNames: null,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectUser(
      SelectUser event,
      Emitter<UsersState> emit,
      ) {
    final userName = event.userName;

    // ✅ نتأكد إن المستخدم موجود
    final userExists = state.users.any((user) => user.fullUserName == userName);

    if (userExists) {
      emit(
        state.copyWith(
          selectedUserName: userName, // ✅ التغيير المهم هنا
          selectedUserNames: {userName},
        ),
      );
    }
  }
}