import '../../../../../../core/helper/helper.dart';
import '../../data_source/get_areas_datasource.dart';
import '../../models/areas_model.dart';
import 'areas_event.dart';

class AreasBloc extends Bloc<AreasEvent, BaseState<AreasModel>> {
  final GetAreasDataSource _getAreasDataSource;
  AreasBloc(this._getAreasDataSource) : super(BaseState()) {
    on<AreasEvent>(_areasEvent);
  }

  Future<void> _areasEvent(AreasEvent event, Emitter<BaseState<AreasModel>> emit) async {
    emit(state.copyWith(status: Status.loading));

    if (event is GetAreasEvent) {
      final result = await _getAreasDataSource.getAreas();
      result.fold(
            (failure) => emit(state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        )),
            (areas) => emit(state.copyWith(
          status: Status.success,
          items: areas,
        )),
      );
    } else if (event is GetAreasByGovernorateIdEvent) {
      final result = await _getAreasDataSource.getAreasByGovernorateId(governorateId: event.governorateId);
      result.fold(
            (failure) => emit(state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        )),
            (areas) => emit(state.copyWith(
          status: Status.success,
          items: areas,
        )),
      );
    }
  }
}