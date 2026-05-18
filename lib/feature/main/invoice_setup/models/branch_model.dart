part of '../invoice_setup_imports.dart';

class BranchModel extends Equatable {
  final int branchId;
  final String branchArName;
  final String branchEnName;

  const BranchModel({
    required this.branchId,
    required this.branchArName,
    required this.branchEnName,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId:     json['CompanyBranchID'] ?? json['BranchID'] ?? json['ID'] ?? 0,
      branchArName: json['ArabicBranchName'] ?? json['BranchArName'] ?? json['BraName'] ?? '',
      branchEnName: json['EnglishBranchName'] ?? json['BranchEnName'] ?? json['BranchEName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'CompanyBranchID':  branchId,
    'ArabicBranchName': branchArName,
    'EnglishBranchName': branchEnName,
  };

  @override
  List<Object?> get props => [branchId];
}