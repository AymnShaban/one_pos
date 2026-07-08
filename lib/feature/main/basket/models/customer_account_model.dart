part of '../basket_imports.dart';

/// A customer account returned by the account-search endpoints.
/// Handles both the PascalCase shape (GetAllCustomersAccountByName) and the
/// camelCase shape (GetCustomersAccountToEmployee); the API also misspells
/// some keys as "acount..." — kept as-is in fromJson.
class CustomerAccountModel extends Equatable {
  final int accountId;
  final String accountCode;
  final String accountArName;
  final String accountEnName;
  final String? phone;
  final double balance;
  final String? fullAddress;
  final String? codeAndArabicName;
  final String? codeAndEnglishName;

  const CustomerAccountModel({
    required this.accountId,
    required this.accountCode,
    required this.accountArName,
    required this.accountEnName,
    this.phone,
    this.balance = 0,
    this.fullAddress,
    this.codeAndArabicName,
    this.codeAndEnglishName,
  });

  factory CustomerAccountModel.fromJson(Map<String, dynamic> json) {
    return CustomerAccountModel(
      accountId: json['AccountID'] ?? json['accountID'] ?? 0,
      accountCode: (json['AcountCode'] ??
              json['AccountCode'] ??
              json['acountCode'] ??
              '')
          .toString(),
      accountArName:
          json['AcountName'] ?? json['AccountName'] ?? json['acountName'] ?? '',
      accountEnName: json['AcountEnglishName'] ??
          json['AccountEnglishName'] ??
          json['acountEnglishName'] ??
          '',
      phone: (json['Phone1'] ?? json['phone1']) as String?,
      balance: ((json['Balance'] ?? json['balance']) as num?)?.toDouble() ?? 0,
      fullAddress: json['FullAddress'] as String?,
      codeAndArabicName:
          json['CodeAndArabicName'] ?? json['codeAndArabicName'] as String?,
      codeAndEnglishName:
          json['CodeAndEnglishName'] ?? json['codeAndEnglishName'] as String?,
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
        'CodeAndArabicName': codeAndArabicName,
        'CodeAndEnglishName': codeAndEnglishName,
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
