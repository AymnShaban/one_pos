part of '../../home_imports.dart';

abstract class TopSellingEvent extends Equatable {
  const TopSellingEvent();

  @override
  List<Object?> get props => [];
}

class LoadTopSellingItems extends TopSellingEvent {
  final int top;
  final String sortBy;

  const LoadTopSellingItems({
    this.top = 5,
    this.sortBy = 'qty',
  });

  @override
  List<Object?> get props => [top, sortBy];
}

class RefreshTopSellingItems extends TopSellingEvent {
  final int top;
  final String sortBy;

  const RefreshTopSellingItems({
    this.top = 5,
    this.sortBy = 'qty',
  });

  @override
  List<Object?> get props => [top, sortBy];
}