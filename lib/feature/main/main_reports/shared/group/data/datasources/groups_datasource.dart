import '../../../shared_imports.dart';
abstract interface class GroupsDataSource {
  Future<Either<Failure, List<GroupModel>>> getGroups();
}

class GroupsDataSourceImpl implements GroupsDataSource {
  final GenericDataSource _generic;

  GroupsDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<GroupModel>>> getGroups() {
    return _generic.fetchData<GroupModel>(
      endpoint: EndPoints.getGroups,
      fromJson: GroupModel.fromJson,
    );
  }
}