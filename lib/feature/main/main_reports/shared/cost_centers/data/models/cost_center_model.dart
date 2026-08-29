
import '../../../shared_imports.dart';
class CostCenterModel extends Equatable {
  final int coID;
  final String code;
  final String coName;
  final String coeName;
  final int nSons;
  final double debit;
  final double credit;
  final String? notes;
  final int? parentID;
  final String address;
  final String resbPerson;
  final String? tel;
  final double? projectValue;
  final double? total;
  final String coType;
  final int? iD_GBranches;
  final bool isSuspended;
  final int? customerID;
  final String codeAndArabicName;
  final String codeAndEnglishName;

  const CostCenterModel({
    required this.coID,
    required this.code,
    required this.coName,
    required this.coeName,
    required this.nSons,
    required this.debit,
    required this.credit,
    this.notes,
    this.parentID,
    required this.address,
    required this.resbPerson,
    this.tel,
    this.projectValue,
    this.total,
    required this.coType,
    this.iD_GBranches,
    required this.isSuspended,
    this.customerID,
    required this.codeAndArabicName,
    required this.codeAndEnglishName,
  });

  factory CostCenterModel.fromJson(Map<String, dynamic> json) {
    return CostCenterModel(
      coID: json['coID'] ?? 0,
      code: json['code']?.toString() ?? '',
      coName: json['coName'] ?? '',
      coeName: json['coeName'] ?? '',
      nSons: json['nSons'] ?? 0,
      debit: (json['debit'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
      notes: json['notes']?.toString(),
      parentID: json['parentID'],
      address: json['address'] ?? '',
      resbPerson: json['resbPerson'] ?? '',
      tel: json['tel']?.toString(),
      projectValue: json['projectValue']?.toDouble(),
      total: json['total']?.toDouble(),
      coType: json['coType'] ?? '',
      iD_GBranches: json['iD_GBranches'],
      isSuspended: json['isSuspended'] ?? false,
      customerID: json['customerID'],
      codeAndArabicName: json['codeAndArabicName'] ?? '',
      codeAndEnglishName: json['codeAndEnglishName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coID': coID,
      'code': code,
      'coName': coName,
      'coeName': coeName,
      'nSons': nSons,
      'debit': debit,
      'credit': credit,
      'notes': notes,
      'parentID': parentID,
      'address': address,
      'resbPerson': resbPerson,
      'tel': tel,
      'projectValue': projectValue,
      'total': total,
      'coType': coType,
      'iD_GBranches': iD_GBranches,
      'isSuspended': isSuspended,
      'customerID': customerID,
      'codeAndArabicName': codeAndArabicName,
      'codeAndEnglishName': codeAndEnglishName,
    };
  }

  @override
  List<Object?> get props => [
    coID,
    code,
    coName,
    coeName,
    nSons,
    debit,
    credit,
    notes,
    parentID,
    address,
    resbPerson,
    tel,
    projectValue,
    total,
    coType,
    iD_GBranches,
    isSuspended,
    customerID,
    codeAndArabicName,
    codeAndEnglishName,
  ];
}