import  'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../core/local/hive_service_impl.dart';
import '../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../../../core/http/either.dart';
import '../../data_source/auth_data_source.dart';
import '../../models/activation_model.dart';
import '../../models/device_info_model.dart';
import 'activation_event.dart';

class ActivationBloc extends Bloc<ActivationEvent, BaseState<ActivationModel>> {
  final AuthDataSource _dataSource;
  final DeviceInfoModel _deviceInfo = DeviceInfoModel();

  final key1Controller = TextEditingController();
  final key2Controller = TextEditingController();
  final key3Controller = TextEditingController();
  final key4Controller = TextEditingController();
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();

  ActivationBloc({required AuthDataSource dataSource})
    : _dataSource = dataSource,
      super(const BaseState()) {
    on<CheckActivationCode>(_onCheck);
    on<CheckDeviceActivation>(_onCheckDevice);

  }

  Future<void> initDevice(BuildContext context) async {
    await _deviceInfo.init(context);
  }

  Future<void> _onCheck(
    CheckActivationCode event,
    Emitter<BaseState<ActivationModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.getDeviceConfig(
      key1: event.key1,
      key2: event.key2,
      key3: event.key3,
      key4: event.key4,
      deviceCode: _deviceInfo.deviceCode ?? '',
      deviceWifiMAC: _deviceInfo.wifiMacAddress ?? '',
      deviceModel: _deviceInfo.deviceModel ?? '',
      deviceName: _deviceInfo.deviceName ?? '',
    );

    if (result.isError) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: result.throwError().message,
        ),
      );
      return;
    }

    final config = result.getOrThrow();
    await _saveConfig(
      config: config,
      activationCode: '${event.key1}-${event.key2}-${event.key3}-${event.key4}',
    );
    emit(state.copyWith(status: Status.success, items: [config]));
  }

  Future<void> _onCheckDevice(
    CheckDeviceActivation event,
    Emitter<BaseState<ActivationModel>> emit,
  ) async {
    final activationCode = HiveServiceImpl.instance.getActivationCode() ?? '';
    if (activationCode.isEmpty) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'no_activation_code',
        ),
      );
      return;
    }

    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.checkDeviceActivation(
      activationCode: activationCode,
      deviceCode: _deviceInfo.deviceCode ?? '',
      deviceWifiMAC: _deviceInfo.wifiMacAddress ?? '',
      deviceModel: _deviceInfo.deviceModel ?? '',
      deviceName: _deviceInfo.deviceName ?? '',
    );

    result.fold(
      (failure) {
        // device_deactivated → wipe config so splash routes to activation
        if (failure.message == 'device_deactivated') {
          _clearConfig();
        }
        emit(
          state.copyWith(status: Status.failure, errorMessage: failure.message),
        );
      },
      (_) => emit(
        state.copyWith(status: Status.success, metadata: {'isActive': true}),
      ),
    );
  }

  Future<void> _saveConfig({
    required ActivationModel config,
    required String activationCode,
  }) async {
    final hive = HiveServiceImpl.instance;
    final json = config.toJson();
    await hive.saveActivationCode(activationCode);
    await hive.saveAppConfig(json);
    debugPrint('[Activation] saved activationCode: $activationCode');
    debugPrint('[Activation] saved appConfig: $json');
  }

  Future<void> _clearConfig() async {
    final hive = HiveServiceImpl.instance;
    await hive.clearAppConfig();
  }

  void moveToNextField(String value, FocusNode current, FocusNode? next) {
    if (value.length == 4) {
      next != null ? next.requestFocus() : current.unfocus();
    }
  }

  void pasteFullCode(String value) {
    if (!value.contains('-')) return;
    final parts = value.split('-');
    if (parts.isNotEmpty) key1Controller.text = parts[0];
    if (parts.length > 1) key2Controller.text = parts[1];
    if (parts.length > 2) key3Controller.text = parts[2];
    if (parts.length > 3) key4Controller.text = parts[3];
    if (parts.length >= 4) {
      focusNode4.unfocus();
    } else if (parts.length == 3) {
      focusNode4.requestFocus();
    } else if (parts.length == 2) {
      focusNode3.requestFocus();
    } else {
      focusNode2.requestFocus();
    }
  }
  @override
  Future<void> close() {
    key1Controller.dispose();
    key2Controller.dispose();
    key3Controller.dispose();
    key4Controller.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    return super.close();
  }
}
