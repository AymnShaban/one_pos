import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'user_model.g.dart';

/// Maps the response from `POST /api/Auth/login`. The JWT itself lives in
/// `token` and is *also* persisted separately via `HiveServiceImpl.saveJwtToken`
/// so the Dio interceptor can stamp the `Authorization: Bearer …` header
/// without having to deserialize the user model on every request.
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
  final String token;
  @HiveField(5)
  final String accessPermission;
  @HiveField(6)
  final String accBR;
  @HiveField(7)
  final bool showPrice;
  @HiveField(8)
  final String? ciAccP;
  @HiveField(9)
  final bool fullAccess;
  @HiveField(10)
  final String userBranches;
  @HiveField(11)
  final List<String> userBranchesList;
  @HiveField(12)
  final String userStores;
  @HiveField(13)
  final List<String> userStoresList;

  const UserModel({
    required this.userId,
    required this.userName,
    required this.fullUserName,
    required this.token,
    this.employeeId,
    this.accessPermission = '',
    this.accBR = '',
    this.showPrice = false,
    this.ciAccP,
    this.fullAccess = false,
    this.userBranches = '',
    this.userBranchesList = const [],
    this.userStores = '',
    this.userStoresList = const [],
  });

  /// `/api/Auth/login` returns a single object (not a list) with these
  /// camelCase / snake-case-mixed keys:
  /// `{ token, usID, usName, accessPermission, fullUserName, accBR,
  ///    showPrice, employeeID, ciAccP, full_Access, userBranches,
  ///    userBranchesList, userStores, userStoresList, … }`
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: (json['usID'] as num?)?.toInt() ?? 0,
      userName: json['usName'] as String? ?? '',
      fullUserName: json['fullUserName'] as String? ?? '',
      employeeId: (json['employeeID'] as num?)?.toInt(),
      token: json['token'] as String? ?? '',
      accessPermission: json['accessPermission'] as String? ?? '',
      accBR: json['accBR'] as String? ?? '',
      showPrice: json['showPrice'] as bool? ?? false,
      ciAccP: json['ciAccP'] as String?,
      fullAccess: json['full_Access'] as bool? ?? false,
      userBranches: json['userBranches'] as String? ?? '',
      userBranchesList: (json['userBranchesList'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      userStores: json['userStores'] as String? ?? '',
      userStoresList: (json['userStoresList'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  int get id => employeeId ?? userId;

  /// Back-compat shim — older call sites read `employeeName`; map it to the
  /// full user name so name-display widgets keep working without edits.
  String get employeeName => fullUserName;

  /// Old code branched on `haveDiscount`. The new contract drops it; default
  /// to 1 (== allowed) so existing discount UI stays open.
  int get haveDiscount => 1;

  Map<String, dynamic> toJson() => {
        'usID': userId,
        'usName': userName,
        'fullUserName': fullUserName,
        'employeeID': employeeId,
        'token': token,
        'accessPermission': accessPermission,
        'accBR': accBR,
        'showPrice': showPrice,
        'ciAccP': ciAccP,
        'full_Access': fullAccess,
        'userBranches': userBranches,
        'userBranchesList': userBranchesList,
        'userStores': userStores,
        'userStoresList': userStoresList,
      };

  @override
  List<Object?> get props => [
        userId,
        userName,
        fullUserName,
        employeeId,
        token,
        accessPermission,
        accBR,
        showPrice,
        ciAccP,
        fullAccess,
        userBranches,
        userBranchesList,
        userStores,
        userStoresList,
      ];
}
