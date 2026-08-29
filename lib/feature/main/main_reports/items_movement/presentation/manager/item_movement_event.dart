import '../../items_movement_import.dart';

abstract class ItemMovementEvent extends Equatable {
  const ItemMovementEvent();

  @override
  List<Object?> get props => [];
}

// ===== Events خاصة بالتقرير فقط =====
class LoadItemMovementReport extends ItemMovementEvent {
  final ItemMovementRequestModel request;

  const LoadItemMovementReport({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class ClearItemMovementReport extends ItemMovementEvent {
  const ClearItemMovementReport();
}