import 'package:equatable/equatable.dart';

class NavState extends Equatable {
  final int currentIndex;

  const NavState({this.currentIndex = 0});

  NavState copyWith({int? currentIndex}) {
    return NavState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}