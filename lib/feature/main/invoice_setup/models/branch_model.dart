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
      branchId:     json['CompanyBranchID'] ?? json['BranchID'] ?? 0,
      branchArName: json['ArabicBranchName'] ?? json['BranchArName'] ?? '',
      branchEnName: json['EnglishBranchName'] ?? json['BranchEnName'] ?? '',
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