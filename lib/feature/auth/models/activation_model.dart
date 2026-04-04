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
    return ActivationModel(
      connectionId:      json['ConnectionID']      ?? '',
      dbDescription:     json['DBDescription']     ?? '',
      dbName:            json['DBName']             ?? '',
      password:          json['PassWord']           ?? '',
      server:            json['Server']             ?? '',
      userName:          json['UserName']           ?? '',
      publicKey:         json['PublicKey']          ?? '',
      privateKey:        json['PrivateKey']         ?? '',
      authorization:     json['Authorization']      ?? '',
      signature:         json['Signature']          ?? '',
      lastLoginName:     json['LastLoginName']      ?? '',
      lastLoginPassword: json['LastLoginPassword']  ?? '',
      baseUrl:           json['BaseURL']            ?? '',
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