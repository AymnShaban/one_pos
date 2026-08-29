
import '../../../entries_imports.dart';

abstract class EntriesEvent extends Equatable {
  const EntriesEvent();

  @override
  List<Object?> get props => [];
}

class LoadVoucherTypes extends EntriesEvent {}

class LoadVouchers extends EntriesEvent {
  final int vouchTypeId;

  const LoadVouchers({required this.vouchTypeId});

  @override
  List<Object?> get props => [vouchTypeId];
}

class LoadVoucherTypeDetails extends EntriesEvent {
  final int frmNum;

  const LoadVoucherTypeDetails({required this.frmNum});

  @override
  List<Object?> get props => [frmNum];
}

class LoadVoucherById extends EntriesEvent {
  final int frmNum;
  final int etNumber;

  const LoadVoucherById({
    required this.frmNum,
    required this.etNumber,
  });

  @override
  List<Object?> get props => [frmNum, etNumber];
}

// ===== الأحداث الجديدة =====
class LoadCashDesks extends EntriesEvent {}


class ClearEntries extends EntriesEvent {}