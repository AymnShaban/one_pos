import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int userId;
  final String userName;
  final String fullUserName;
  final int? employeeId;
  final String? employeeName;
  final int haveDiscount;
  final List<dynamic> userPermissions;

  const UserModel({
    required this.userId,
    required this.userName,
    required this.fullUserName,
    this.employeeId,
    this.employeeName,
    this.haveDiscount = 1,
    this.userPermissions = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId:          json['UserID']          ?? 0,
      userName:        json['UserName']        ?? '',
      fullUserName:    json['FullUserName']     ?? '',
      employeeId:      json['EmployeeID'],
      employeeName:    json['EmployeeName'],
      haveDiscount:    json['HaveDiscount']    ?? 1,
      userPermissions: json['UserPermissions'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'UserID':          userId,
    'UserName':        userName,
    'FullUserName':    fullUserName,
    'EmployeeID':      employeeId,
    'EmployeeName':    employeeName,
    'HaveDiscount':    haveDiscount,
    'UserPermissions': userPermissions,
  };

  @override
  List<Object?> get props => [userId, userName, fullUserName];
}