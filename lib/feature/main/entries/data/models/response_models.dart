import  '../../entries_imports.dart';
class PostEntryResponseModel {
  final bool success;
  final String message;
  final int? entryNumber;

  PostEntryResponseModel({
    required this.success,
    required this.message,
    this.entryNumber,
  });

  factory PostEntryResponseModel.fromJson(Map<String, dynamic> json) {
    return PostEntryResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      entryNumber: json['entryNumber'] as int?,
    );
  }
}

class SaveJournalEntryResponseModel {
  final bool success;
  final String message;

  SaveJournalEntryResponseModel({
    required this.success,
    required this.message,
  });

  factory SaveJournalEntryResponseModel.fromJson(Map<String, dynamic> json) {
    return SaveJournalEntryResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}