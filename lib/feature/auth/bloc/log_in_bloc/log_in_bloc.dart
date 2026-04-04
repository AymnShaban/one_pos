import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/hive_service_impl.dart';
import '../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../data_source/auth_data_source.dart';
import '../../models/activation_model.dart';
import '../../models/user_model.dart';
import 'log_in_event.dart';

class LoginBloc extends Bloc<LoginEvent, BaseState<UserModel>> {
  final AuthDataSource _dataSource;

  LoginBloc({required AuthDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState()) {
    on<LoginSubmitted>(_onLogin);
  }

  Future<void> _onLogin(
      LoginSubmitted event,
      Emitter<BaseState<UserModel>> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    // Load saved config
    final configJson = HiveServiceImpl.instance.getAppConfig();
    if (configJson == null) {
      emit(state.copyWith(
        status:       Status.failure,
        errorMessage: 'no_configuration_found',
      ));
      return;
    }

    final config = ActivationModel.fromJson(
      Map<String, dynamic>.from(configJson),
    );

    final result = await _dataSource.login(
      userName: event.userName,
      password: event.password,
      config:   config,
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status:       Status.failure,
        errorMessage: failure.message,
      )),
          (user) async {
        // Save logged-in user locally
        await HiveServiceImpl.instance.saveLoggedInUser(user.toJson());
        // Save seller name + userId for use in invoices
        await HiveServiceImpl.instance.saveUserId(user.userId);
        await HiveServiceImpl.instance.saveSellerName(user.fullUserName);
        await HiveServiceImpl.instance.saveHaveDiscount(user.haveDiscount);

        emit(state.copyWith(
          status: Status.success,
          items:  [user],
        ));
      },
    );
  }
}