part of '../../settings_imports.dart';

class SettingsBloc extends Bloc<SettingsEvent, BaseState<UserSettingsModel>> {
  final HiveServiceImpl _hiveService;

  SystemInfoModel systemInfo = const SystemInfoModel();

  SettingsBloc({required HiveServiceImpl hiveService})
      : _hiveService = hiveService,
        super(const BaseState()) {
    on<LoadSettings>(_onLoad);
    on<LogoutRequested>(_onLogout);
    on<UpdateDatabase>(_onUpdateDatabase);
    on<ToggleNotifications>(_onToggleNotifications);
  }

  void _onLoad(
    LoadSettings event,
    Emitter<BaseState<UserSettingsModel>> emit,
  ) {
    emit(state.copyWith(status: Status.loading));
    try {
      // Read the typed UserModel that login persisted via cacheUserModel().
      // Everything below is sourced from that record — no hard-coded values.
      final user = _hiveService.getUserModel();

      final model = UserSettingsModel(
        fullName: user?.fullUserName.isNotEmpty == true
            ? user!.fullUserName
            : (user?.userName ?? ''),
        role: (user?.fullAccess ?? false)
            ? 'settings.role_admin'.tr()
            : 'settings.role_user'.tr(),
        // The server returns a comma-joined branch-id string (e.g. "1,2").
        // Display verbatim — looking up branch *names* would need BranchBloc
        // here, which we deliberately keep out of the settings bloc.
        branch: user?.userBranches ?? '',
        // The JWT carries an `iat` (issued-at) claim — decode it for the
        // user's last successful login timestamp. No extra Hive field needed.
        lastLogin: _lastLoginFromToken(user?.token ?? ''),
        isOnline: true,
      );
      emit(state.copyWith(status: Status.success, items: [model]));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Decodes the JWT's middle segment, reads `iat` (issued-at, seconds since
  /// epoch) and returns a short formatted string. Falls back to empty on any
  /// parse error — the UI just shows a blank line.
  String _lastLoginFromToken(String token) {
    if (token.isEmpty) return '';
    try {
      final parts = token.split('.');
      if (parts.length != 3) return '';
      var payload = parts[1];
      // base64Url requires '=' padding to a multiple of 4.
      payload += '=' * ((4 - payload.length % 4) % 4);
      final json = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(json) as Map<String, dynamic>;
      final iat = map['iat'];
      if (iat is! int) return '';
      final dt = DateTime.fromMillisecondsSinceEpoch(iat * 1000).toLocal();
      String two(int v) => v.toString().padLeft(2, '0');
      return '${dt.year}/${two(dt.month)}/${two(dt.day)}  '
          '${two(dt.hour)}:${two(dt.minute)}';
    } catch (_) {
      return '';
    }
  }

  void _onLogout(
      LogoutRequested event,
      Emitter<BaseState<UserSettingsModel>> emit,
      ) async {
    await _hiveService.clearUserModel();
    await _hiveService.clearJwtToken();
    emit(state.copyWith(status: Status.success, metadata: {'action': 'logout'}));
  }

  void _onUpdateDatabase(
      UpdateDatabase event,
      Emitter<BaseState<UserSettingsModel>> emit,
      ) {
    // Wire to API later
  }

  void _onToggleNotifications(
      ToggleNotifications event,
      Emitter<BaseState<UserSettingsModel>> emit,
      ) {
    // Wire to local settings later
  }
}