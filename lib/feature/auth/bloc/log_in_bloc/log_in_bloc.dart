import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../data_source/login_data_source.dart';
import 'log_in_event.dart';

class LoginBloc extends Bloc<LoginEvent, BaseState<String>> {
  final LoginDataSource _loginDataSource;

  LoginBloc({required LoginDataSource loginDataSource})
    : _loginDataSource = loginDataSource,
      super(const BaseState<String>()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<BaseState<String>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _loginDataSource.login(
      phone: event.phone,
      password: event.password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
      (token) {
       emit(state.copyWith(status: Status.success));
      },
    );
  }
}
