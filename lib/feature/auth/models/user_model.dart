import   'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends Equatable {
  @HiveField(0)
  final int userId;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final String fullUserName;
  @HiveField(3)
  final int? employeeId;
  @HiveField(4)
  final String? employeeName;
  @HiveField(5)
  final int haveDiscount;
  @HiveField(6)
  final List<dynamic> userPermissions;
  @HiveField(7)
  final List<dynamic> accessPermission;

  const UserModel({
    required this.userId,
    required this.userName,
    required this.fullUserName,
    this.employeeId,
    this.employeeName,
    this.haveDiscount = 1,
    this.userPermissions = const [],
    this.accessPermission = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['UserID'] ?? 0,
      userName: json['UserName'] ?? '',
      fullUserName: json['FullUserName'] ?? '',
      employeeId: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      haveDiscount: json['HaveDiscount'] ?? 1,
      userPermissions: json['UserPermissions'] ?? [],
      accessPermission: json['AccessPermission'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'UserID': userId,
    'UserName': userName,
    'FullUserName': fullUserName,
    'EmployeeID': employeeId,
    'EmployeeName': employeeName,
    'HaveDiscount': haveDiscount,
    'UserPermissions': userPermissions,
    'AccessPermission': accessPermission,
  };

  @override
  List<Object?> get props => [
    userId,
    userName,
    fullUserName,
    employeeId,
    employeeName,
    haveDiscount,
    userPermissions,
  ];
}

// [{"serverName":null,"DBName":null,"serverUserName":null,"serverPassword":null,"AccessPermission":null,"HaveDiscount":1,"UserPermissions":[]}]
