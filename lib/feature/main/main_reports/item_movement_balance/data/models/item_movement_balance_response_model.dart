class ItemMovementBalanceResponseModel {
  final bool success;
  final String? message;
  final List<ItemMovementBalanceItemModel> rows;

  const ItemMovementBalanceResponseModel({
    required this.success,
    this.message,
    required this.rows,
  });

  factory ItemMovementBalanceResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ItemMovementBalanceResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString(),
      rows: (json['rows'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(ItemMovementBalanceItemModel.fromJson)
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'rows': rows.map((item) => item.toJson()).toList(),
    };
  }
}

class ItemMovementBalanceItemModel {
  final bool isGroupHeader;
  final String? groupName;
  final int level;

  final String mtid;
  final String mtName;
  final String mtEName;
  final String barcode;

  final String groupID;
  final String groupNameField;

  // Beginning Balance
  final double bRasid;
  final double bCost;
  final double bTotal;

  // Incoming
  final double matEnt;
  final double entCost;
  final double entTotal;

  // Outgoing
  final double matOut;
  final double outCost;
  final double outTotal;

  // Balance
  final double matRasid;
  final double matCost;
  final double matTotal;

  // After Balance
  final double afRasid;
  final double afCost;
  final double afTotal;

  const ItemMovementBalanceItemModel({
    required this.isGroupHeader,
    this.groupName,
    required this.level,
    required this.mtid,
    required this.mtName,
    required this.mtEName,
    required this.barcode,
    required this.groupID,
    required this.groupNameField,
    required this.bRasid,
    required this.bCost,
    required this.bTotal,
    required this.matEnt,
    required this.entCost,
    required this.entTotal,
    required this.matOut,
    required this.outCost,
    required this.outTotal,
    required this.matRasid,
    required this.matCost,
    required this.matTotal,
    required this.afRasid,
    required this.afCost,
    required this.afTotal,
  });

  factory ItemMovementBalanceItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ItemMovementBalanceItemModel(
      isGroupHeader: json['isGroupHeader'] as bool? ?? false,
      groupName: json['groupName']?.toString(),
      level: (json['level'] as num?)?.toInt() ?? 0,

      mtid: json['mtid']?.toString() ?? '',
      mtName: json['mtName']?.toString() ?? '',
      mtEName: json['mtEName']?.toString() ?? '',
      barcode: json['barcode']?.toString() ?? '',

      groupID: json['groupID']?.toString() ?? '',
      groupNameField: json['groupNameField']?.toString() ?? '',

      bRasid: (json['bRasid'] as num?)?.toDouble() ?? 0.0,
      bCost: (json['bCost'] as num?)?.toDouble() ?? 0.0,
      bTotal: (json['bTotal'] as num?)?.toDouble() ?? 0.0,

      matEnt: (json['matEnt'] as num?)?.toDouble() ?? 0.0,
      entCost: (json['entCost'] as num?)?.toDouble() ?? 0.0,
      entTotal: (json['entTotal'] as num?)?.toDouble() ?? 0.0,

      matOut: (json['matOut'] as num?)?.toDouble() ?? 0.0,
      outCost: (json['outCost'] as num?)?.toDouble() ?? 0.0,
      outTotal: (json['outTotal'] as num?)?.toDouble() ?? 0.0,

      matRasid: (json['matRasid'] as num?)?.toDouble() ?? 0.0,
      matCost: (json['matCost'] as num?)?.toDouble() ?? 0.0,
      matTotal: (json['matTotal'] as num?)?.toDouble() ?? 0.0,

      afRasid: (json['afRasid'] as num?)?.toDouble() ?? 0.0,
      afCost: (json['afCost'] as num?)?.toDouble() ?? 0.0,
      afTotal: (json['afTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isGroupHeader': isGroupHeader,
      'groupName': groupName,
      'level': level,

      'mtid': mtid,
      'mtName': mtName,
      'mtEName': mtEName,
      'barcode': barcode,

      'groupID': groupID,
      'groupNameField': groupNameField,

      'bRasid': bRasid,
      'bCost': bCost,
      'bTotal': bTotal,

      'matEnt': matEnt,
      'entCost': entCost,
      'entTotal': entTotal,

      'matOut': matOut,
      'outCost': outCost,
      'outTotal': outTotal,

      'matRasid': matRasid,
      'matCost': matCost,
      'matTotal': matTotal,

      'afRasid': afRasid,
      'afCost': afCost,
      'afTotal': afTotal,
    };
  }
}