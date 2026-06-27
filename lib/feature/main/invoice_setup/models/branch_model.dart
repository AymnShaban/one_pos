part of '../invoice_setup_imports.dart';

/// Maps `GET /api/GBranch/GetCompanyBranchesByUserIDV2`. Server now sends
/// lowercase-first keys (`id`, `braName`, `braEName`, …); the legacy
/// `BranchID` / `BranchArName` / `BranchEnName` fallbacks stay so any cached
/// or mocked payloads keep parsing.
///
/// Public getters `branchId`, `branchArName`, `branchEnName` are preserved
/// — every consumer (SalesSetupBar, collection_mobile_layout, dropdown
/// builders) reads them by name and shouldn't move.
class BranchModel extends Equatable {
  final int branchId;
  final String branchArName;
  final String branchEnName;
  final String branchCode;
  final int currencyId;
  final bool deactivated;
  final String codeAndArabicName;
  final String codeAndEnglishName;

  const BranchModel({
    required this.branchId,
    required this.branchArName,
    required this.branchEnName,
    this.branchCode = '',
    this.currencyId = -1,
    this.deactivated = false,
    this.codeAndArabicName = '',
    this.codeAndEnglishName = '',
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    int? i(dynamic v) => (v as num?)?.toInt();
    String? s(dynamic v) => v as String?;

    return BranchModel(
      branchId: i(json['id']) ??
          i(json['CompanyBranchID']) ??
          i(json['BranchID']) ??
          i(json['ID']) ??
          0,
      branchArName: s(json['braName']) ??
          s(json['ArabicBranchName']) ??
          s(json['BranchArName']) ??
          s(json['BraName']) ??
          '',
      branchEnName: s(json['braEName']) ??
          s(json['EnglishBranchName']) ??
          s(json['BranchEnName']) ??
          s(json['BranchEName']) ??
          '',
      branchCode: s(json['braCode']) ?? s(json['BranchCode']) ?? '',
      currencyId: i(json['currencyID']) ?? i(json['CurrencyID']) ?? -1,
      deactivated: json['deactivated'] == true || json['Deactivated'] == true,
      codeAndArabicName:
          s(json['codeAndArabicName']) ?? s(json['CodeAndArabicName']) ?? '',
      codeAndEnglishName:
          s(json['codeAndEnglishName']) ?? s(json['CodeAndEnglishName']) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': branchId,
        'braCode': branchCode,
        'braName': branchArName,
        'braEName': branchEnName,
        'currencyID': currencyId,
        'deactivated': deactivated,
        'codeAndArabicName': codeAndArabicName,
        'codeAndEnglishName': codeAndEnglishName,
      };

  @override
  List<Object?> get props => [branchId];
}
