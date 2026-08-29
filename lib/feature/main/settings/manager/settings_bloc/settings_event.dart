part of '../../settings_imports.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class LogoutRequested extends SettingsEvent {
  const LogoutRequested();
}

class UpdateDatabase extends SettingsEvent {
  const UpdateDatabase();
}

class ToggleNotifications extends SettingsEvent {
  const ToggleNotifications();
}
class ResetActivationRequested extends SettingsEvent {
  const ResetActivationRequested();
}
