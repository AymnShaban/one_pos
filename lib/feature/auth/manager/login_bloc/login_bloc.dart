import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../data_source/login_data_source.dart';
import '../../models/customer_model.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, BaseState<CustomerModel>> {
  final LoginDataSource _dataSource;

  LoginBloc({required LoginDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState()) {
    on<LoginSubmitted>(_onLogin);
  }

  Future<void> _onLogin(
      LoginSubmitted event,
      Emitter<BaseState<CustomerModel>> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.login(
      phone:    event.phone,
      password: event.password,
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status:       Status.failure,
        errorMessage: failure.message,
      )),
          (customer) => emit(state.copyWith(
        status: Status.success,
        items:  [customer],
      )),
    );
  }
}