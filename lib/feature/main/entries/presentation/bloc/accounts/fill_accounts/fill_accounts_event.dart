import '../accounts_event.dart';

class LoadFillAccounts extends AccountsEvent {
  final String entryType;
  final int branchId;
  final String? userName;
  final int limitAccessEntry;
  final int mainAcIDs;

  const LoadFillAccounts({
    required this.entryType,
    required this.branchId,
    this.userName,
    this.limitAccessEntry = 0,
    this.mainAcIDs = 0,
  });

  @override
  List<Object?> get props => [entryType, branchId, userName, limitAccessEntry, mainAcIDs];
}

class ClearFillAccounts extends AccountsEvent {}