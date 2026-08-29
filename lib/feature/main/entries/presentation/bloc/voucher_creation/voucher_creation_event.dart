import '../../../entries_imports.dart';

abstract class VoucherCreationEvent extends Equatable {
  const VoucherCreationEvent();

  @override
  List<Object?> get props => [];
}

class CreateVoucher extends VoucherCreationEvent {
  final PostEntryRequestModel request;

  const CreateVoucher({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class ResetVoucherCreation extends VoucherCreationEvent {}