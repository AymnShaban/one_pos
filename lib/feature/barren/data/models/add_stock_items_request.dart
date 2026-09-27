class AddStockItemsRequest {
  final String storeCode;
  final List<AddStockItem> items;

  const AddStockItemsRequest({
    required this.storeCode,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeCode': storeCode,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class AddStockItem {
  final String mtid;
  final int qty;
  final String barcode;

  const AddStockItem({
    required this.mtid,
    required this.qty,
    required this.barcode,
  });

  Map<String, dynamic> toJson() {
    return {
      'mtid': mtid,
      'qty': qty,
      'barcode': barcode,
    };
  }
}