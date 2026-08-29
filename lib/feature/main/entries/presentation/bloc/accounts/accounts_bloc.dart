// // accounts_bloc.dart
//
// import '../../../entries_imports.dart';
//
// class AccountsBloc extends Bloc<AccountsEvent, BaseState<List<AccountModel>>> {
//   final EntriesDataSource _dataSource;
//
//   AccountBalanceModel? _accountBalance;
//   List<AccountModel>? _fillAccounts;
//
//   AccountsBloc({
//     required EntriesDataSource dataSource,
//   })  : _dataSource = dataSource,
//         super(const BaseState<List<AccountModel>>()) {
//     on<LoadAccounts>(_onLoadAccounts);
//     on<LoadAccountBalance>(_onLoadAccountBalance);
//     on<LoadFillAccounts>(_onLoadFillAccounts);
//     on<ClearAccounts>(_onClearAccounts);
//   }
//
//   AccountBalanceModel? get accountBalance => _accountBalance;
//   List<AccountModel>? get fillAccounts => _fillAccounts;
//
//   Future<void> _onLoadAccounts(
//       LoadAccounts event,
//       Emitter<BaseState<List<AccountModel>>> emit,
//       ) async {
//     if (state.status == Status.loading) return;
//
//     emit(
//       state.copyWith(
//         status: Status.loading,
//         errorMessage: null,
//         failure: null,
//       ),
//     );
//
//     final result = await _dataSource.getAllAccounts();
//
//     result.fold(
//           (failure) {
//         emit(
//           state.copyWith(
//             status: Status.failure,
//             errorMessage: failure.message,
//             failure: failure,
//           ),
//         );
//       },
//           (accounts) {
//         emit(
//           state.copyWith(
//             status: Status.success,
//             data: accounts,
//             errorMessage: null,
//             failure: null,
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _onLoadAccountBalance(
//       LoadAccountBalance event,
//       Emitter<BaseState<List<AccountModel>>> emit,
//       ) async {
//     final result = await _dataSource.getAccountBalance(event.acId);
//
//     result.fold(
//           (failure) {
//         _accountBalance = null;
//       },
//           (balance) {
//         _accountBalance = balance;
//       },
//     );
//   }
//
//
//   Future<void> _onLoadFillAccounts(
//       LoadFillAccounts event,
//       Emitter<BaseState<List<AccountModel>>> emit,
//       ) async {
//     if (state.status == Status.loading) return;
//
//     emit(
//       state.copyWith(
//         status: Status.loading,
//         errorMessage: null,
//         failure: null,
//       ),
//     );
//
//     final result = await _dataSource.getFillAccountList(
//       entryType: event.entryType,
//       branchId: event.branchId,
//       userName: event.userName,
//       limitAccessEntry: event.limitAccessEntry,
//       mainAcIDs: event.mainAcIDs,
//     );
//
//     result.fold(
//           (failure) {
//         emit(
//           state.copyWith(
//             status: Status.failure,
//             errorMessage: failure.message,
//             failure: failure,
//           ),
//         );
//       },
//           (accounts) {
//         _fillAccounts = accounts;
//         emit(
//           state.copyWith(
//             status: Status.success,
//             data: accounts,
//             errorMessage: null,
//             failure: null,
//           ),
//         );
//       },
//     );
//   }
//
//   void _onClearAccounts(
//       ClearAccounts event,
//       Emitter<BaseState<List<AccountModel>>> emit,
//       ) {
//     _accountBalance = null;
//     _fillAccounts = null;
//     emit(const BaseState<List<AccountModel>>());
//   }
// }