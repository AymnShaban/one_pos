part of "hive_service_impl.dart";
abstract interface class IUserCache {
  Future<void> cacheUserModel(CustomerModel userModel);
  CustomerModel? getUserModel();
  Future<void> clearUserModel();
  Future<void> updateCachedUserModel(CustomerModel userModel);
  Future<void> cacheOrderId(String orderId);
  Future<void> upDateOrderId(String orderId);
  String? getOrderId();
  Future<void> saveLocation({
    required String address,
    String? districtName,
    String? regionName,
    String? addressNotes,
    double? latitude,
    double? longitude,
  });
  Map<String, dynamic>? getLocation();
  Future<void> saveProfileImage(String path);
  String? getProfileImage();
}

