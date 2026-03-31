


import 'package:one_pos/core/helper/time_picker_helper.dart';

import 'helper.dart';

class ConnectivityService {
  ConnectivityService._() {
    _init();
  }

  static final ConnectivityService instance = ConnectivityService._();

  final _controller = StreamController<bool>.broadcast();
  bool _wasPreviouslyOffline = true;

  Stream<bool> get onConnectivityChanged => _controller.stream;

  void _init() async {
    // Initial internet check to set the correct state
    final hasInitialInternet = await InternetConnection().hasInternetAccess;
    _wasPreviouslyOffline = !hasInitialInternet;

    Connectivity().onConnectivityChanged.listen((result) async {
      final hasInternet = await InternetConnection().hasInternetAccess;

      if (hasInternet && _wasPreviouslyOffline) {
        TimerHelper.throttle(() {
          _controller.add(true); // trigger sync
        });
      }

      _wasPreviouslyOffline = !hasInternet;
    });
  }
}