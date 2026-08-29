



import '../../../../invoice_profit_imports.dart';


import '../../../../invoice_profit_imports.dart';

class UsersState extends Equatable {
  final Status status;
  final List<UserModel> users;
  final Set<String> selectedUserNames; // ✅ بقينا نخزن أسماء مش IDs
  final String? selectedUserName;
  final String? errorMessage;

  const UsersState({
    this.status = Status.initial,
    this.users = const [],
    this.selectedUserNames = const {},
    this.selectedUserName,
    this.errorMessage,
  });

  // Helper getters
  bool get hasUsers => users.isNotEmpty;

  UserModel? get selectedUser {
    if (selectedUserName == null) return null;
    try {
      return users.firstWhere(
            (user) => user.fullUserName == selectedUserName,
      );
    } catch (e) {
      return null;
    }
  }

  UsersState copyWith({
    Status? status,
    List<UserModel>? users,
    Set<String>? selectedUserNames,
    String? selectedUserName,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      selectedUserNames: selectedUserNames ?? this.selectedUserNames,
      selectedUserName: clearSelected
          ? null
          : (selectedUserName ?? this.selectedUserName), // ✅ صح
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    users,
    selectedUserNames,
    selectedUserName,
    errorMessage,
  ];
}