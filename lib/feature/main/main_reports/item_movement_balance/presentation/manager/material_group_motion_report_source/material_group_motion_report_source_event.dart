import '../../../item_movement_balance_import.dart';
abstract class MaterialGroupMotionReportSourceEvent
    extends Equatable {
  const MaterialGroupMotionReportSourceEvent();

  @override
  List<Object?> get props => [];
}

class LoadMaterialGroupMotionReportSources
    extends MaterialGroupMotionReportSourceEvent {
  const LoadMaterialGroupMotionReportSources();
}

class SelectMaterialGroupMotionReportSource
    extends MaterialGroupMotionReportSourceEvent {
  final int frmNum;

  const SelectMaterialGroupMotionReportSource({
    required this.frmNum,
  });

  @override
  List<Object?> get props => [frmNum];
}