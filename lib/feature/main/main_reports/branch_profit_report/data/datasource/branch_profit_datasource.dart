import '../../branch_profit_import.dart';

abstract class BranchProfitDataSource {
  Future<Either<Failure, BranchProfitResponseModel>> getReport(
      BranchProfitRequestModel request,
      );
}

class BranchProfitDataSourceImpl implements BranchProfitDataSource {
  final GenericDataSource genericDataSource;

  BranchProfitDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, BranchProfitResponseModel>> getReport(
      BranchProfitRequestModel request,
      ) async {
    return genericDataSource.postData<BranchProfitResponseModel>(
      endpoint: EndPoints.branchProfitReport, // هتحطه في EndPoints
      data: request.toJson(),
      fromJson: (json) => BranchProfitResponseModel.fromJson(json),
    );
  }
}