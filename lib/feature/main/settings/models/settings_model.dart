part of '../settings_imports.dart';

class UserSettingsModel extends Equatable {
  final String fullName;
  final String role;
  final String branch;
  final String lastLogin;
  final bool isOnline;

  const UserSettingsModel({
    this.fullName = '',
    this.role = '',
    this.branch = '',
    this.lastLogin = '',
    this.isOnline = false,
  });

  UserSettingsModel copyWith({
    String? fullName,
    String? role,
    String? branch,
    String? lastLogin,
    bool? isOnline,
  }) {
    return UserSettingsModel(
      fullName:  fullName  ?? this.fullName,
      role:      role      ?? this.role,
      branch:    branch    ?? this.branch,
      lastLogin: lastLogin ?? this.lastLogin,
      isOnline:  isOnline  ?? this.isOnline,
    );
  }

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      fullName:  json['FullName']  ?? '',
      role:      json['Role']      ?? '',
      branch:    json['Branch']    ?? '',
      lastLogin: json['LastLogin'] ?? '',
      isOnline:  json['IsOnline']  ?? false,
    );
  }

  @override
  List<Object?> get props => [fullName, role, branch, lastLogin, isOnline];
}

class SystemInfoModel extends Equatable {


  final String lastSync;
  final bool isConnected;

  const SystemInfoModel({


    this.lastSync    = '',
    this.isConnected = false,
  });

  @override
  List<Object?> get props => [  lastSync, isConnected];
}