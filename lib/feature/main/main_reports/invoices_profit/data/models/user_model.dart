
import '../../invoice_profit_imports.dart';

class UserModel extends Equatable {
  final int usId;
  final String fullUserName;

  const UserModel({
    required this.usId,
    required this.fullUserName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      usId: json['usId'] ?? 0,
      fullUserName: json['fullUserName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usId': usId,
      'fullUserName': fullUserName,
    };
  }

  @override
  List<Object?> get props => [usId, fullUserName];
}