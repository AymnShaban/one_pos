

import '../../../../../core/helper/helper.dart';

sealed class ReportsVisibilityEvent {
  const ReportsVisibilityEvent();
}

class ToggleReportsVisibility extends ReportsVisibilityEvent {
  const ToggleReportsVisibility();
}

class ReportsVisibilityBloc
    extends Bloc<ReportsVisibilityEvent, bool> {
  ReportsVisibilityBloc() : super(true) {
    on<ToggleReportsVisibility>(_onToggle);
  }

  void _onToggle(
      ToggleReportsVisibility event,
      Emitter<bool> emit,
      ) {
    emit(!state);
  }
}