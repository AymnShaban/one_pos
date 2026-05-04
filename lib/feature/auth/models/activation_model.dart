import 'package:equatable/equatable.dart';

class ActivationModel extends Equatable {
  final String connectionId;
  final String dbDescription;
  final String dbName;
  final String password;
  final String server;
  final String userName;
  final String publicKey;
  final String privateKey;
  final String authorization;
  final String signature;
  final String lastLoginName;
  final String lastLoginPassword;
  final String baseUrl;

  const ActivationModel({
    this.connectionId    = '',
    this.dbDescription   = '',
    this.dbName          = '',
    this.password        = '',
    this.server          = '',
    this.userName        = '',
    this.publicKey       = '',
    this.privateKey      = '',
    this.authorization   = '',
    this.signature       = '',
    this.lastLoginName   = '',
    this.lastLoginPassword = '',
    this.baseUrl         = '',
  });

  factory ActivationModel.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => v?.toString() ?? '';
    return ActivationModel(
      connectionId:      s(json['ConnectionID']),
      dbDescription:     s(json['DBDescription']),
      dbName:            s(json['DBName']),
      password:          s(json['PassWord']),
      server:            s(json['Server']),
      userName:          s(json['UserName']),
      publicKey:         s(json['PublicKey']),
      privateKey:        s(json['PrivateKey']),
      authorization:     s(json['Authorization']),
      signature:         s(json['Signature']),
      lastLoginName:     s(json['LastLoginName']),
      lastLoginPassword: s(json['LastLoginPassword']),
      baseUrl:           s(json['BaseURL']),
    );
  }

  Map<String, dynamic> toJson() => {
    'ConnectionID':      connectionId,
    'DBDescription':     dbDescription,
    'DBName':            dbName,
    'PassWord':          password,
    'Server':            server,
    'UserName':          userName,
    'PublicKey':         publicKey,
    'PrivateKey':        privateKey,
    'Authorization':     authorization,
    'Signature':         signature,
    'LastLoginName':     lastLoginName,
    'LastLoginPassword': lastLoginPassword,
    'BaseURL':           baseUrl,
  };

  ActivationModel copyWith({
    String? connectionId,
    String? dbDescription,
    String? dbName,
    String? password,
    String? server,
    String? userName,
    String? publicKey,
    String? privateKey,
    String? authorization,
    String? signature,
    String? lastLoginName,
    String? lastLoginPassword,
    String? baseUrl,
  }) {
    return ActivationModel(
      connectionId:      connectionId      ?? this.connectionId,
      dbDescription:     dbDescription     ?? this.dbDescription,
      dbName:            dbName            ?? this.dbName,
      password:          password          ?? this.password,
      server:            server            ?? this.server,
      userName:          userName          ?? this.userName,
      publicKey:         publicKey         ?? this.publicKey,
      privateKey:        privateKey        ?? this.privateKey,
      authorization:     authorization     ?? this.authorization,
      signature:         signature         ?? this.signature,
      lastLoginName:     lastLoginName     ?? this.lastLoginName,
      lastLoginPassword: lastLoginPassword ?? this.lastLoginPassword,
      baseUrl:           baseUrl           ?? this.baseUrl,
    );
  }

  @override
  List<Object?> get props => [
    connectionId, dbName, server,
    publicKey, privateKey, authorization,
  ];
}