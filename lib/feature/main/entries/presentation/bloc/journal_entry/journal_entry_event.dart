import '../../../entries_imports.dart';


abstract class JournalEntryEvent extends Equatable {
  const JournalEntryEvent();

  @override
  List<Object?> get props => [];
}

class SaveJournalEntry extends JournalEntryEvent {
  final SaveJournalEntryRequestModel request;

  const SaveJournalEntry({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class ResetJournalEntry extends JournalEntryEvent {}