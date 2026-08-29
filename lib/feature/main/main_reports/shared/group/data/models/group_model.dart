import '../../../shared_imports.dart';
class GroupModel extends Equatable {
  final int id;
  final String groupID;
  final String groupName;
  final String groupEName;
  final String? parentId;
  final String? parentDisplay;
  final String? notes;
  final bool isClinicsGroup;
  final bool isRestGroup;
  final bool isSalonGroup;
  final bool stopGroup;
  final bool notShowingInTheApp;
  final bool invisibleGroup;

  const GroupModel({
    required this.id,
    required this.groupID,
    required this.groupName,
    required this.groupEName,
    this.parentId,
    this.parentDisplay,
    this.notes,
    required this.isClinicsGroup,
    required this.isRestGroup,
    required this.isSalonGroup,
    required this.stopGroup,
    required this.notShowingInTheApp,
    required this.invisibleGroup,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? 0,
      groupID: json['groupID']?.toString() ?? '',
      groupName: json['groupName'] ?? '',
      groupEName: json['groupEName'] ?? '',
      parentId: json['parentId']?.toString(),
      parentDisplay: json['parentDisplay'],
      notes: json['notes'],
      isClinicsGroup: json['isClinicsGroup'] ?? false,
      isRestGroup: json['isRestGroup'] ?? false,
      isSalonGroup: json['isSalonGroup'] ?? false,
      stopGroup: json['stopGroup'] ?? false,
      notShowingInTheApp: json['notShowingInTheApp'] ?? false,
      invisibleGroup: json['invisibleGroup'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupID': groupID,
      'groupName': groupName,
      'groupEName': groupEName,
      'parentId': parentId,
      'parentDisplay': parentDisplay,
      'notes': notes,
      'isClinicsGroup': isClinicsGroup,
      'isRestGroup': isRestGroup,
      'isSalonGroup': isSalonGroup,
      'stopGroup': stopGroup,
      'notShowingInTheApp': notShowingInTheApp,
      'invisibleGroup': invisibleGroup,
    };
  }

  @override
  List<Object?> get props => [
    id,
    groupID,
    groupName,
    groupEName,
    parentId,
    parentDisplay,
    notes,
    isClinicsGroup,
    isRestGroup,
    isSalonGroup,
    stopGroup,
    notShowingInTheApp,
    invisibleGroup,
  ];
}