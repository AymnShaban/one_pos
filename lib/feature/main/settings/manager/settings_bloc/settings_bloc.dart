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
     // final user = _hiveService.getUserModel();
      final model = UserSettingsModel(
        fullName: "أيمن شعبان" ,// "${user?.arabicName} ${user?.lastName}"
        role:      'مدير النظام',
        branch:    'فرع الرياض الرئيسي',
        lastLogin: 'اليوم ٨:٣٠ صباحاً',
        isOnline:  true,
      );
      emit(state.copyWith(status: Status.success, items: [model]));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onLogout(
      LogoutRequested event,
      Emitter<BaseState<UserSettingsModel>> emit,
      ) async {
    await _hiveService.clearUserModel();
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