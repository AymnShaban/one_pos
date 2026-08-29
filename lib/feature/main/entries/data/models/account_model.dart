import 'package:easy_localization/easy_localization.dart';

import  '../../entries_imports.dart';
class AccountModel {
  final int? acID;
  final String? acCode;
  final String? acName;
  final String? acEName;
  final int? parentID;
  final String? codeAndArabicName;
  final String? codeAndEnglishName;

  AccountModel({
    this.acID,
    this.acCode,
    this.acName,
    this.acEName,
    this.parentID,
    this.codeAndArabicName,
    this.codeAndEnglishName,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      acID: json['acID'] as int?,
      acCode: json['acCode'] as String?,
      acName: json['acName'] as String?,
      acEName: json['acEName'] as String?,
      parentID: json['parentID'] as int?,
      codeAndArabicName: json['codeAndArabicName'] as String?,
      codeAndEnglishName: json['codeAndEnglishName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acID': acID,
      'acCode': acCode,
      'acName': acName,
      'acEName': acEName,
      'parentID': parentID,
      'codeAndArabicName': codeAndArabicName,
      'codeAndEnglishName': codeAndEnglishName,
    };
  }

  String getDisplayName(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return isArabic
        ? (codeAndArabicName ?? acName ?? acCode ?? '')
        : (codeAndEnglishName ?? acEName ?? acCode ?? '');
  }


}