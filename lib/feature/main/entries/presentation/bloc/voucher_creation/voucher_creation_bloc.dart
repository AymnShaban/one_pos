import 'dart:convert';

import '../../../entries_imports.dart';

class VoucherCreationBloc
    extends Bloc<
        VoucherCreationEvent,
        BaseState<PostEntryResponseModel>
    > {
  final EntriesDataSource _dataSource;

  VoucherCreationBloc({
    required EntriesDataSource dataSource,
  })  : _dataSource = dataSource,
        super(const BaseState<PostEntryResponseModel>()) {
    on<CreateVoucher>(_onCreateVoucher);
    on<ResetVoucherCreation>(_onResetVoucherCreation);
  }

  Future<void> _onCreateVoucher(
      CreateVoucher event,
      Emitter<BaseState<PostEntryResponseModel>> emit,
      ) async {
    if (state.status == Status.loading) return;

    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
      ),
    );

    final result = await _dataSource.postEntry(event.request);
    debugPrint(
      const JsonEncoder.withIndent('  ').convert(event.request),
    );
    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
            failure: failure,
          ),
        );
      },
          (response) {
        emit(
          state.copyWith(
            status: Status.success,
            data: response,
            errorMessage: null,
            failure: null,
          ),
        );
      },
    );
  }

  void _onResetVoucherCreation(
      ResetVoucherCreation event,
      Emitter<BaseState<PostEntryResponseModel>> emit,
      ) {
    emit(const BaseState<PostEntryResponseModel>());
  }
}