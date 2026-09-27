import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  ActivationBloc({
    required AuthDataSource dataSource,
  })  : _dataSource = dataSource,
        super(const BaseState()) {
    on<CheckActivationCode>(_onCheck);
    on<CheckDeviceActivation>(_onCheckDevice);
  }

  Future<void> initDevice(BuildContext context) async {
    await _deviceInfo.init(context);
  }

  // ============================================================
  // Activation Code
  // ============================================================

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
      final failure = result.throwError();

      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      );

      return;
    }

    final config = result.getOrThrow();

    // ============================================================
    // BaseURL القادم من API
    // ============================================================

    debugPrint('');
    debugPrint('════════════════════════════════════════════');
    debugPrint('[Activation] API Response');
    debugPrint('[Activation] BaseURL from API:');
    debugPrint(
      config.baseUrl.isNotEmpty ? config.baseUrl : 'NULL / EMPTY',
    );
    debugPrint('════════════════════════════════════════════');

    final activationCode =
        '${event.key1}-${event.key2}-${event.key3}-${event.key4}';

    // ============================================================
    // Save Activation + App Config
    // ============================================================

    await _saveConfig(
      config: config,
      activationCode: activationCode,
    );

    emit(
      state.copyWith(
        status: Status.success,
        items: [config],
      ),
    );
  }

  // ============================================================
  // Check Device Activation
  // ============================================================

  Future<void> _onCheckDevice(
      CheckDeviceActivation event,
      Emitter<BaseState<ActivationModel>> emit,
      ) async {
    final hive = HiveServiceImpl.instance;

    final activationCode = hive.getActivationCode() ?? '';

    if (activationCode.isEmpty) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'no_activation_code',
        ),
      );

      return;
    }

    // ============================================================
    // قراءة BaseURL من Hive
    // ============================================================

    final savedBaseUrl = hive.getBaseUrl();

    debugPrint('');
    debugPrint('════════════════════════════════════════════');
    debugPrint('[Activation] Check Device');
    debugPrint('[Activation] Activation Code: $activationCode');
    debugPrint('[Activation] BaseURL from Hive:');
    debugPrint(
      savedBaseUrl != null && savedBaseUrl.trim().isNotEmpty
          ? savedBaseUrl
          : 'NULL / EMPTY',
    );
    debugPrint('[Activation] Full App Config:');
    debugPrint(hive.getAppConfig().toString());
    debugPrint('════════════════════════════════════════════');

    emit(
      state.copyWith(
        status: Status.loading,
      ),
    );

    final result = await _dataSource.checkDeviceActivation(
      activationCode: activationCode,
      deviceCode: _deviceInfo.deviceCode ?? '',
      deviceWifiMAC: _deviceInfo.wifiMacAddress ?? '',
      deviceModel: _deviceInfo.deviceModel ?? '',
      deviceName: _deviceInfo.deviceName ?? '',
    );

    result.fold(
          (failure) async {
        // ========================================================
        // Device Deactivated
        // ========================================================

        if (failure.message == 'device_deactivated') {
          await _clearConfig();
        }

        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
          ),
        );
      },
          (_) {
        debugPrint(
          '[Activation] Device activation check succeeded',
        );

        emit(
          state.copyWith(
            status: Status.success,
            metadata: {
              'isActive': true,
            },
          ),
        );
      },
    );
  }

  // ============================================================
  // Save Activation Config
  // ============================================================

  Future<void> _saveConfig({
    required ActivationModel config,
    required String activationCode,
  }) async {
    final hive = HiveServiceImpl.instance;

    final json = config.toJson();

    // ============================================================
    // Before Hive Save
    // ============================================================

    debugPrint('');
    debugPrint('════════════════════════════════════════════');
    debugPrint('[Activation] Before Hive Save');

    debugPrint('[Activation] Activation Code:');
    debugPrint(activationCode);

    debugPrint('[Activation] BaseURL from API:');
    debugPrint(
      config.baseUrl.isNotEmpty ? config.baseUrl : 'NULL / EMPTY',
    );

    debugPrint('[Activation] App Config to Save:');
    debugPrint(json.toString());

    debugPrint('════════════════════════════════════════════');

    // ============================================================
    // Save Activation Code
    // ============================================================

    await hive.saveActivationCode(
      activationCode,
    );

    // ============================================================
    // Save Full App Config
    // ============================================================

    await hive.saveAppConfig(
      json,
    );

    // ============================================================
    // Read Again From Hive
    // ============================================================

    final savedActivationCode =
    hive.getActivationCode();

    final savedConfig =
    hive.getAppConfig();

    final savedBaseUrl =
    hive.getBaseUrl();

    // ============================================================
    // After Hive Save
    // ============================================================

    debugPrint('');
    debugPrint('════════════════════════════════════════════');
    debugPrint('[Activation] After Hive Save');

    debugPrint('[Activation] Activation Code from Hive:');
    debugPrint(
      savedActivationCode ?? 'NULL',
    );

    debugPrint('[Activation] BaseURL from API:');
    debugPrint(
      config.baseUrl.isNotEmpty ? config.baseUrl : 'NULL / EMPTY',
    );

    debugPrint('[Activation] BaseURL from Hive:');
    debugPrint(
      savedBaseUrl != null && savedBaseUrl.trim().isNotEmpty
          ? savedBaseUrl
          : 'NULL / EMPTY',
    );

    debugPrint('[Activation] Full App Config from Hive:');
    debugPrint(
      savedConfig?.toString() ?? 'NULL',
    );

    debugPrint('════════════════════════════════════════════');
    debugPrint('');
  }

  // ============================================================
  // Clear Activation Config
  // ============================================================

  Future<void> _clearConfig() async {
    final hive = HiveServiceImpl.instance;

    await hive.clearAppConfig();

    final baseUrlAfterClear =
    hive.getBaseUrl();

    final activationCodeAfterClear =
    hive.getActivationCode();

    debugPrint('');
    debugPrint('════════════════════════════════════════════');
    debugPrint('[Activation] App Config Cleared');
    debugPrint(
      '[Activation] Activation Code after clear: '
          '${activationCodeAfterClear ?? 'NULL'}',
    );
    debugPrint(
      '[Activation] BaseURL after clear: '
          '${baseUrlAfterClear ?? 'NULL'}',
    );
    debugPrint('════════════════════════════════════════════');
    debugPrint('');
  }

  // ============================================================
  // Move To Next Field
  // ============================================================

  void moveToNextField(
      String value,
      FocusNode current,
      FocusNode? next,
      ) {
    if (value.length == 4) {
      next != null
          ? next.requestFocus()
          : current.unfocus();
    }
  }

  // ============================================================
  // Paste Full Activation Code
  // ============================================================

  void pasteFullCode(String value) {
    if (!value.contains('-')) return;

    final parts = value.split('-');

    if (parts.isNotEmpty) {
      key1Controller.text = parts[0];
    }

    if (parts.length > 1) {
      key2Controller.text = parts[1];
    }

    if (parts.length > 2) {
      key3Controller.text = parts[2];
    }

    if (parts.length > 3) {
      key4Controller.text = parts[3];
    }

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

  // ============================================================
  // Dispose
  // ============================================================

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