class MainAccountModel {
  final int? acId;
  final String? acCode;
  final String? acName;
  final String? acEName;
  final int? parentId;
  final String? codeAndArabicName;
  final String? codeAndEnglishName;
  final dynamic debit;
  final dynamic credit;
  final dynamic balance;
  final String? phone1;
  final String? phone2;

  const MainAccountModel({
    this.acId,
    this.acCode,
    this.acName,
    this.acEName,
    this.parentId,
    this.codeAndArabicName,
    this.codeAndEnglishName,
    this.debit,
    this.credit,
    this.balance,
    this.phone1,
    this.phone2,
  });

  factory MainAccountModel.fromJson(Map<String, dynamic> json) {
    return MainAccountModel(
      acId: json['acID'] as int?,
      acCode: json['acCode']?.toString(),
      acName: json['acName']?.toString(),
      acEName: json['acEName']?.toString(),
      parentId: json['parentID'] as int?,
      codeAndArabicName: json['codeAndArabicName']?.toString(),
      codeAndEnglishName: json['codeAndEnglishName']?.toString(),
      debit: json['debit'],
      credit: json['credit'],
      balance: json['balance'],
      phone1: json['phone1']?.toString(),
      phone2: json['phone2']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acID': acId,
      'acCode': acCode,
      'acName': acName,
      'acEName': acEName,
      'parentID': parentId,
      'codeAndArabicName': codeAndArabicName,
      'codeAndEnglishName': codeAndEnglishName,
      'debit': debit,
      'credit': credit,
      'balance': balance,
      'phone1': phone1,
      'phone2': phone2,
    };
  }

  String get displayName => acName ?? acCode ?? '';

  String get displayCode => acCode ?? '';

  int get id => acId ?? 0;
}
