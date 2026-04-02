import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_nav_event.dart';
import 'bottom_nav_states.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(const NavState()) {
    on<ChangeNavTab>(_onChangeTab);
  }

  void _onChangeTab(ChangeNavTab event, Emitter<NavState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }
}