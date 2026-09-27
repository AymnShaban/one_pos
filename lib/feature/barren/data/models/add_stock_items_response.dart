class AddStockItemsResponse {
  final bool success;
  final String message;

  const AddStockItemsResponse({required this.success, required this.message});

  factory AddStockItemsResponse.fromJson(Map<String, dynamic> json) {
    return AddStockItemsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
    );
  }
}
