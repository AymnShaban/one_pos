import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../core/local/hive_service_impl.dart';
import '../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../data_source/auth_data_source.dart';
import '../../models/activation_model.dart';
import '../../models/device_info_model.dart';
import 'activation_event.dart';

class ActivationBloc
    extends Bloc<ActivationEvent, BaseState<ActivationModel>> {
  final AuthDataSource _dataSource;
  final DeviceInfoModel _deviceInfo = DeviceInfoModel();

  // Key controllers — managed here so screen stays StatelessWidget
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
    on<DeactivateDevice>(_onDeactivate);
  }

  Future<void> initDevice(BuildContext context) async {
    await _deviceInfo.init(context);
  }

  Future<void> _onCheck(
      CheckActivationCode event,
      Emitter<BaseState<ActivationModel>> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.checkActivationCode(
      key1:          event.key1,
      key2:          event.key2,
      key3:          event.key3,
      key4:          event.key4,
      deviceCode:    _deviceInfo.deviceCode    ?? '',
      deviceWifiMAC: _deviceInfo.wifiMacAddress ?? '',
      deviceModel:   _deviceInfo.deviceModel   ?? '',
      deviceName:    _deviceInfo.deviceName    ?? '',
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status:       Status.failure,
        errorMessage: failure.message,
      )),
          (config) async {
        // Save everything locally
        await _saveConfig(
          config:         config,
          activationCode: '${event.key1}-${event.key2}-${event.key3}-${event.key4}',
        );
        emit(state.copyWith(
          status: Status.success,
          items:  [config],
        ));
      },
    );
  }

  Future<void> _onCheckDevice(
      CheckDeviceActivation event,
      Emitter<BaseState<ActivationModel>> emit,
      ) async {
    final activationCode =
        HiveServiceImpl.instance.getActivationCode() ?? '';
    if (activationCode.isEmpty) {
      emit(state.copyWith(
        status:       Status.failure,
        errorMessage: 'no_activation_code',
      ));
      return;
    }

    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.checkDeviceActivation(
      activationCode: activationCode,
      deviceCode:     _deviceInfo.deviceCode    ?? '',
      deviceWifiMAC:  _deviceInfo.wifiMacAddress ?? '',
      deviceModel:    _deviceInfo.deviceModel   ?? '',
      deviceName:     _deviceInfo.deviceName    ?? '',
    );

    result.fold(
          (failure) {
        // device_deactivated → wipe config so splash routes to activation
        if (failure.message == 'device_deactivated') {
          _clearConfig();
        }
        emit(state.copyWith(
          status:       Status.failure,
          errorMessage: failure.message,
        ));
      },
          (_) => emit(state.copyWith(
        status:   Status.success,
        metadata: {'isActive': true},
      )),
    );
  }

  Future<void> _onDeactivate(
      DeactivateDevice event,
      Emitter<BaseState<ActivationModel>> emit,
      ) async {
    final activationCode =
        HiveServiceImpl.instance.getActivationCode() ?? '';
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.deactivateDevice(
      activationCode: activationCode,
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status:       Status.failure,
        errorMessage: failure.message,
      )),
          (_) async {
        await _clearConfig();
        emit(state.copyWith(
          status:   Status.success,
          metadata: {'action': 'deactivated'},
        ));
      },
    );
  }

  Future<void> _saveConfig({
    required ActivationModel config,
    required String activationCode,
  }) async {
    final hive = HiveServiceImpl.instance;
    await hive.saveActivationCode(activationCode);
    await hive.saveAppConfig(config.toJson());
  }

  Future<void> _clearConfig() async {
    final hive = HiveServiceImpl.instance;
    await hive.clearAppConfig();
  }

  void moveToNextField(
      String value,
      FocusNode current,
      FocusNode? next,
      ) {
    if (value.length == 4) {
      next != null ? next.requestFocus() : current.unfocus();
    }
  }

  void pasteFullCode(String value) {
    final parts = value.split('-');
    if (parts.isNotEmpty)        key1Controller.text = parts[0];
    if (parts.length > 1)        key2Controller.text = parts[1];
    if (parts.length > 2)        key3Controller.text = parts[2];
    if (parts.length > 3)        key4Controller.text = parts[3];
    if (parts.isNotEmpty)        focusNode2.requestFocus();
    if (parts.length > 1)        focusNode3.requestFocus();
    if (parts.length > 2)        focusNode4.requestFocus();
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