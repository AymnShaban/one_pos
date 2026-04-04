import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class DeviceInfoModel {
  String? wifiMacAddress;
  String? deviceModel;
  String? deviceName;
  String? deviceCode;

  Future<void> init(BuildContext context) async {
    final networkInfo = NetworkInfo();
    final deviceInfo = DeviceInfoPlugin();

    wifiMacAddress = await networkInfo.getWifiBSSID() ?? '';

    if (context.mounted) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final android = await deviceInfo.androidInfo;
        deviceModel = android.model;
        deviceName = android.device;
        deviceCode = android.id;
      } else {
        final ios = await deviceInfo.iosInfo;
        deviceModel = ios.utsname.machine;
        deviceName = ios.name;
        deviceCode = wifiMacAddress;
      }
    }
  }
}
