import 'package:equatable/equatable.dart';

import '../../helper/helper.dart';

part  "enum_event.dart";
part  "enum_state.dart";



abstract class EnumBloc<T extends Enum> extends Bloc<EnumEvent<T>, EnumState<T>> {
  EnumBloc(
      List<T> values, {
        required T initial,
      }) : super(EnumState(values: values, selected: initial)) {
    on<SelectEnumValue<T>>((event, emit) {
      emit(state.copyWith(selected: event.value));
    });
  }
}