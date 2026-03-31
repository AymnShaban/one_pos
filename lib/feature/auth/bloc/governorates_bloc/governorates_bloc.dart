import '../../../../../../core/helper/helper.dart';
import '../../data_source/get_areas_datasource.dart';
import '../../models/governorates_model.dart';
import 'governorates_event.dart';

class GovernoratesBloc extends Bloc<GovernoratesEvent, BaseState<GovernoratesModel>> {
  final GetAreasDataSource _getAreasDataSource;

  GovernoratesBloc(this._getAreasDataSource) : super(BaseState()) {
    on<GetGovernoratesEvent>(_onGetGovernorates);
  }

  Future<void> _onGetGovernorates(
      GetGovernoratesEvent event, Emitter<BaseState<GovernoratesModel>> emit) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _getAreasDataSource.getGovernorates();
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
      (governorates) => emit(state.copyWith(
        status: Status.success,
        items: governorates,
      )),
    );
  }
}
