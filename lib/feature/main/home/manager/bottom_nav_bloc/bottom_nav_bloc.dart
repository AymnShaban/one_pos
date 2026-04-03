part of '../../home_imports.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(const NavState()) {
    on<ChangeNavTab>(_onChangeTab);
  }

  void _onChangeTab(ChangeNavTab event, Emitter<NavState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }
}