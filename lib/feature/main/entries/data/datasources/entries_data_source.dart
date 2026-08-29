// entries_data_source.dart

import '../../entries_imports.dart';

abstract class EntriesDataSource {
  Future<Either<Failure, List<VoucherTypeModel>>> getVoucherTypes();

  Future<Either<Failure, List<AccountModel>>> getAllAccounts();

  Future<Either<Failure, VoucherTypeModel>> getVoucherTypeDetails(
      int frmNum,
      );

  Future<Either<Failure, List<VoucherTypeModel>>> getVouchers(
      int vouchTypeId,
      );



  Future<Either<Failure, PostEntryResponseModel>> postEntry(
      PostEntryRequestModel request,
      );

  Future<Either<Failure, SaveJournalEntryResponseModel>> saveJournalEntry(
      SaveJournalEntryRequestModel request,
      );

  Future<Either<Failure, List<EtsPatternModel>>> getEtsPatterns(
      int vouchTypeId,
      );

  // ===== الدوال الجديدة =====


  Future<Either<Failure, List<AccountModel>>> getFillAccountList({
    required String entryType,
    required int branchId,
    String? userName,
    int limitAccessEntry = 0,
    int mainAcIDs = 0,
  });

  Future<Either<Failure, AccountBalanceModel>> getAccountBalance(int acId);
}

class EntriesDataSourceImpl implements EntriesDataSource {
  final GenericDataSource _generic;

  const EntriesDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<VoucherTypeModel>>> getVoucherTypes() {
    return _generic.fetchData<VoucherTypeModel>(
      endpoint: EndPoints.getVoucherTypes,
      fromJson: VoucherTypeModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<AccountModel>>> getAllAccounts() {
    return _generic.fetchData<AccountModel>(
      endpoint: EndPoints.getAllAccounts,
      fromJson: AccountModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, VoucherTypeModel>> getVoucherTypeDetails(
      int frmNum,
      ) {
    return _generic.fetchResult<VoucherTypeModel>(
      endpoint: '${EndPoints.getVoucherTypeDetails}/$frmNum',
      fromJson: VoucherTypeModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<VoucherTypeModel>>> getVouchers(
      int vouchTypeId,
      ) {
    return _generic.fetchData<VoucherTypeModel>(
      endpoint: EndPoints.getVouchers,
      queryParameters: {
        'vouchTypeId': vouchTypeId,
      },
      fromJson: VoucherTypeModel.fromJson,
    );
  }



  @override
  Future<Either<Failure, PostEntryResponseModel>> postEntry(
      PostEntryRequestModel request,
      ) {
    return _generic.postData<PostEntryResponseModel>(
      endpoint: EndPoints.postEntry,
      data: request.toJson(),
      fromJson: PostEntryResponseModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, SaveJournalEntryResponseModel>> saveJournalEntry(
      SaveJournalEntryRequestModel request,
      ) {
    return _generic.postData<SaveJournalEntryResponseModel>(
      endpoint: EndPoints.saveJournalEntry,
      data: request.toJson(),
      fromJson: SaveJournalEntryResponseModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<EtsPatternModel>>> getEtsPatterns(
      int vouchTypeId,
      ) {
    return _generic.fetchData<EtsPatternModel>(
      endpoint: EndPoints.getEtsPatterns,
      queryParameters: {
        'vouchTypeId': vouchTypeId,
      },
      fromJson: EtsPatternModel.fromJson,
    );
  }

  // ===== تنفيذ الدوال الجديدة =====
  @override
  Future<Either<Failure, AccountBalanceModel>> getAccountBalance(int acId) {
    return _generic.fetchResult<AccountBalanceModel>(
      endpoint: EndPoints.getAccountBalance(acId:acId),
      fromJson: AccountBalanceModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<AccountModel>>> getFillAccountList({
    required String entryType,
    required int branchId,
    String? userName,
    int limitAccessEntry = 0,
    int mainAcIDs = 0,
  }) {
    return _generic.fetchData<AccountModel>(
      endpoint: EndPoints.fillAccountList,
      queryParameters: {
        'entryType': entryType,
        'branchId': branchId,
        if (userName != null) 'userName': userName,
        'limitAccessEntry': limitAccessEntry,
        'mainAcIDs': mainAcIDs,
      },
      fromJson: AccountModel.fromJson,
    );
  }
}