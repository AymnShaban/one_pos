

import 'package:easy_localization/easy_localization.dart';

class ItemMovementBalanceRequestModel {
  final bool arabic;
  final String stDate;
  final String enDate;
  final String materialId;
  final String groupId;
  final String storeId;
  final String costCenterId;
  final String deputedId;
  final String matType;
  final String unit;
  final String sortBy;
  final int costType;
  final bool showPrice;
  final bool showTotal;
  final bool groupByGroup;
  final bool showEmpty;
  final bool outputAtCost;
  final bool lastPeriod;
  final List<String> sources;
  final List<ExtraField> extraFields;

  const ItemMovementBalanceRequestModel({
    required this.arabic,
    required this.stDate,
    required this.enDate,
    required this.materialId,
    required this.groupId,
    required this.storeId,
    required this.costCenterId,
    required this.deputedId,
    required this.matType,
    required this.unit,
    required this.sortBy,
    required this.costType,
    required this.showPrice,
    required this.showTotal,
    required this.groupByGroup,
    required this.showEmpty,
    required this.outputAtCost,
    required this.lastPeriod,
    required this.sources,
    required this.extraFields,
  });

  factory ItemMovementBalanceRequestModel.create({
    required DateTime fromDate,
    required DateTime toDate,
    String materialId = '',
    String groupId = '',
    String storeId = '',
    String costCenterId = '',
    String deputedId = '',
    String matType = '',
    String unit = '0',
    String sortBy = '',
    int costType = 0,
    bool showPrice = true,
    bool showTotal = true,
    bool groupByGroup = false,
    bool showEmpty = false,
    bool outputAtCost = true,
    bool lastPeriod = false,
    List<String> sources = const [],
    List<ExtraField> extraFields = const [],
    bool arabic = true,
  }) {
    return ItemMovementBalanceRequestModel(
      arabic: arabic,
      stDate: DateFormat('yyyy-MM-dd').format(fromDate),
      enDate: DateFormat('yyyy-MM-dd').format(toDate),
      materialId: materialId,
      groupId: groupId,
      storeId: storeId,
      costCenterId: costCenterId,
      deputedId: deputedId,
      matType: matType,
      unit: unit,
      sortBy: sortBy,
      costType: costType,
      showPrice: showPrice,
      showTotal: showTotal,
      groupByGroup: groupByGroup,
      showEmpty: showEmpty,
      outputAtCost: outputAtCost,
      lastPeriod: lastPeriod,
      sources: sources,
      extraFields: extraFields,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabic': arabic,
      'stDate': stDate,
      'enDate': enDate,
      'materialId': materialId,
      'groupId': groupId,
      'storeId': storeId,
      'costCenterId': costCenterId,
      'deputedId': deputedId,
      'matType': matType,
      'unit': unit,
      'sortBy': sortBy,
      'costType': costType,
      'showPrice': showPrice,
      'showTotal': showTotal,
      'groupByGroup': groupByGroup,
      'showEmpty': showEmpty,
      'outputAtCost': outputAtCost,
      'lastPeriod': lastPeriod,
      'sources': sources,
      'extraFields': extraFields.map((e) => e.toJson()).toList(),
    };
  }
}

class ExtraField {
  final String field;
  final String label;

  const ExtraField({
    required this.field,
    required this.label,
  });

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'label': label,
    };
  }
}