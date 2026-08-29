
import 'package:equatable/equatable.dart';



class AccountBalanceModel extends Equatable {
  final int acID;
  final String acCode;
  final String acName;
  final String acEName;
  final double balance;
  final double credit;
  final double debit;

  const AccountBalanceModel({
    required this.acID,
    required this.acCode,
    required this.acName,
    required this.acEName,
    required this.balance,
    required this.credit,
    required this.debit,
  });

  factory AccountBalanceModel.fromJson(Map<String, dynamic> json) {

    final data = json['data'] ?? json;

    return AccountBalanceModel(
      acID: data['acID'] ?? 0,
      acCode: data['acCode'] ?? '',
      acName: data['acName'] ?? '',
      acEName: data['acEName'] ?? '',
      balance: (data['balance'] ?? 0).toDouble(),
      credit: (data['credit'] ?? 0).toDouble(),
      debit: (data['debit'] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [acID, acCode, acName, balance, credit, debit];
}