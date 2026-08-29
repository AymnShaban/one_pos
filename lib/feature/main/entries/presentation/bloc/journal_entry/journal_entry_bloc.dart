import  '../../../entries_imports.dart';

class JournalEntryBloc
    extends Bloc<
        JournalEntryEvent,
        BaseState<SaveJournalEntryResponseModel>
    > {
  final EntriesDataSource _dataSource;

  JournalEntryBloc({
    required EntriesDataSource dataSource,
  })  : _dataSource = dataSource,
        super(const BaseState<SaveJournalEntryResponseModel>()) {
    on<SaveJournalEntry>(_onSaveJournalEntry);
    on<ResetJournalEntry>(_onResetJournalEntry);
  }

  Future<void> _onSaveJournalEntry(
      SaveJournalEntry event,
      Emitter<BaseState<SaveJournalEntryResponseModel>> emit,
      ) async {
    if (state.status == Status.loading) return;

    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
      ),
    );

    final result = await _dataSource.saveJournalEntry(event.request);

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

  void _onResetJournalEntry(
      ResetJournalEntry event,
      Emitter<BaseState<SaveJournalEntryResponseModel>> emit,
      ) {
    emit(const BaseState<SaveJournalEntryResponseModel>());
  }
}