import  '../../entries_imports.dart';
class SaveJournalEntryRequestModel {
  final int voucherType;
  final DateTime creationDateTime;
  final String? notes;
  final int employeeId;
  final String createdBy;
  final int branchId;
  final int entryLevel;
  final List<JournalEntryAccountModel> voucherAccounts;

  SaveJournalEntryRequestModel({
    required this.voucherType,
    required this.creationDateTime,
    this.notes,
    required this.employeeId,
    required this.createdBy,
    required this.branchId,
    required this.entryLevel,
    required this.voucherAccounts,
  });

  Map<String, dynamic> toJson() {
    return {
      'voucherType': voucherType,
      'creationDateTime': creationDateTime.toIso8601String(),
      'notes': notes,
      'employeeId': employeeId,
      'createdBy': createdBy,
      'branchId': branchId,
      'entryLevel': entryLevel,
      'voucherAccounts': voucherAccounts.map((e) => e.toJson()).toList(),
    };
  }
}

class JournalEntryAccountModel {
  final int acId;
  final double debit;
  final double credit;
  final int currencyId;
  final double currencyRate;
  final int? costCenterId;
  final String? notes;
  final int? acBranchId;

  JournalEntryAccountModel({
    required this.acId,
    required this.debit,
    required this.credit,
    required this.currencyId,
    required this.currencyRate,
    this.costCenterId,
    this.notes,
    this.acBranchId,
  });

  Map<String, dynamic> toJson() {
    return {
      'acId': acId,
      'debit': debit,
      'credit': credit,
      'currencyId': currencyId,
      'currencyRate': currencyRate,
      'costCenterId': costCenterId,
      'notes': notes,
      'acBranchId': acBranchId,
    };
  }
}