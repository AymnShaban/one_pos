part of '../basket_imports.dart';

/// A customer account returned by GetAllCustomersAccountByName.
/// (The API spells some keys "Acount..." — kept as-is in fromJson.)
class CustomerAccountModel extends Equatable {
  final int accountId;
  final String accountCode;
  final String accountArName;
  final String accountEnName;
  final String? phone;
  final double balance;
  final String? fullAddress;

  const CustomerAccountModel({
    required this.accountId,
    required this.accountCode,
    required this.accountArName,
    required this.accountEnName,
    this.phone,
    this.balance = 0,
    this.fullAddress,
  });

  factory CustomerAccountModel.fromJson(Map<String, dynamic> json) {
    return CustomerAccountModel(
      accountId: json['AccountID'] ?? 0,
      accountCode:
          (json['AcountCode'] ?? json['AccountCode'] ?? '').toString(),
      accountArName: json['AcountName'] ?? json['AccountName'] ?? '',
      accountEnName:
          json['AcountEnglishName'] ?? json['AccountEnglishName'] ?? '',
      phone: json['Phone1'] as String?,
      balance: (json['Balance'] as num?)?.toDouble() ?? 0,
      fullAddress: json['FullAddress'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'AccountID': accountId,
        'AcountCode': accountCode,
        'AcountName': accountArName,
        'AcountEnglishName': accountEnName,
        'Phone1': phone,
        'Balance': balance,
        'FullAddress': fullAddress,
      };

  /// Localized name with a fallback to the other language if one is empty.
  String displayName(bool isAr) {
    final primary = isAr ? accountArName : accountEnName;
    if (primary.trim().isNotEmpty) return primary;
    final fallback = isAr ? accountEnName : accountArName;
    return fallback.trim().isNotEmpty ? fallback : accountCode;
  }

  @override
  List<Object?> get props => [accountId];
}
