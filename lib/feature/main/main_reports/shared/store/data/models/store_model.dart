import '../../../shared_imports.dart';
class StoreModel extends Equatable {
  final int id;
  final int branchID;
  final String branchName;
  final String branchEName;
  final String? brShortName;
  final String? loc;
  final String? tel;
  final String? fax;
  final int gBr;
  final String? brIndex;
  final String? debitAccID;
  final String? creditAccID;
  final bool stoped;
  final String? acName_Debit;
  final String? acEName_Debit;
  final String? acCode_Credit;
  final String? acName_Credit;
  final String? acEName_Credit;
  final String codeAndArabicName;
  final String codeAndEnglishName;
  final String gBrDisplay;
  final String? acCode_Debit;
  final String? debitAccDisplay;
  final String? creditAccDisplay;

  const StoreModel({
    required this.id,
    required this.branchID,
    required this.branchName,
    required this.branchEName,
    this.brShortName,
    this.loc,
    this.tel,
    this.fax,
    required this.gBr,
    this.brIndex,
    this.debitAccID,
    this.creditAccID,
    required this.stoped,
    this.acName_Debit,
    this.acEName_Debit,
    this.acCode_Credit,
    this.acName_Credit,
    this.acEName_Credit,
    required this.codeAndArabicName,
    required this.codeAndEnglishName,
    required this.gBrDisplay,
    this.acCode_Debit,
    this.debitAccDisplay,
    this.creditAccDisplay,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? 0,
      branchID: json['branchID'] ?? 0,
      branchName: json['branchName'] ?? '',
      branchEName: json['branchEName'] ?? '',
      brShortName: json['brShortName'],
      loc: json['loc'],
      tel: json['tel'],
      fax: json['fax'],
      gBr: json['gBr'] ?? 0,
      brIndex: json['brIndex'],
      debitAccID: json['debitAccID']?.toString(),
      creditAccID: json['creditAccID']?.toString(),
      stoped: json['stoped'] ?? false,
      acName_Debit: json['acName_Debit'],
      acEName_Debit: json['acEName_Debit'],
      acCode_Credit: json['acCode_Credit'],
      acName_Credit: json['acName_Credit'],
      acEName_Credit: json['acEName_Credit'],
      codeAndArabicName: json['codeAndArabicName'] ?? '',
      codeAndEnglishName: json['codeAndEnglishName'] ?? '',
      gBrDisplay: json['gBrDisplay'] ?? '',
      acCode_Debit: json['acCode_Debit'],
      debitAccDisplay: json['debitAccDisplay'],
      creditAccDisplay: json['creditAccDisplay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branchID': branchID,
      'branchName': branchName,
      'branchEName': branchEName,
      'brShortName': brShortName,
      'loc': loc,
      'tel': tel,
      'fax': fax,
      'gBr': gBr,
      'brIndex': brIndex,
      'debitAccID': debitAccID,
      'creditAccID': creditAccID,
      'stoped': stoped,
      'acName_Debit': acName_Debit,
      'acEName_Debit': acEName_Debit,
      'acCode_Credit': acCode_Credit,
      'acName_Credit': acName_Credit,
      'acEName_Credit': acEName_Credit,
      'codeAndArabicName': codeAndArabicName,
      'codeAndEnglishName': codeAndEnglishName,
      'gBrDisplay': gBrDisplay,
      'acCode_Debit': acCode_Debit,
      'debitAccDisplay': debitAccDisplay,
      'creditAccDisplay': creditAccDisplay,
    };
  }

  @override
  List<Object?> get props => [
    id,
    branchID,
    branchName,
    branchEName,
    brShortName,
    loc,
    tel,
    fax,
    gBr,
    brIndex,
    debitAccID,
    creditAccID,
    stoped,
    acName_Debit,
    acEName_Debit,
    acCode_Credit,
    acName_Credit,
    acEName_Credit,
    codeAndArabicName,
    codeAndEnglishName,
    gBrDisplay,
    acCode_Debit,
    debitAccDisplay,
    creditAccDisplay,
  ];
}