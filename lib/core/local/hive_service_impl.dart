import 'package:hive_flutter/hive_flutter.dart';
import '../../feature/auth/models/areas_model.dart';
import '../../feature/auth/models/customer_model.dart';
import '../helper/logger.dart';
import '../models/item_model.dart';
part 'user_cache_interface.dart';
part 'paginated_cache_interface.dart';

class HiveServiceImpl implements IUserCache {
  static const String userBoxName = 'user_box';
  static Box<CustomerModel>? _userBox;
  static const String currentUserKey = 'current_user';
  static const String orderBoxName = 'order_box';
  static Box<String>? _orderBox;
  static const String selectedAreaBoxName = 'selected_area_box';
  static Box<AreasModel>? _selectedAreaBox;
  static const String locationBoxName = 'location_box';
  static Box<Map>? _locationBox;
  static const String selectedLocationKey = 'selected_location';
  static const String settingsBoxName = 'settings_box';
  static Box? _settingsBox;
  HiveServiceImpl._();

  static final HiveServiceImpl instance = HiveServiceImpl._();

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CustomerModelAdapter());
    Hive.registerAdapter(ItemModelAdapter());
    Hive.registerAdapter(AreasModelAdapter());

    _userBox = await Hive.openBox<CustomerModel>(userBoxName);
    _orderBox = await Hive.openBox<String>(orderBoxName);
    _selectedAreaBox = await Hive.openBox<AreasModel>(selectedAreaBoxName);
    _locationBox = await Hive.openBox<Map>(locationBoxName);
    _settingsBox = await Hive.openBox(settingsBoxName);
  }

  @override
  Future<void> cacheUserModel(CustomerModel user) async {
    await _userBox?.put(currentUserKey, user);
  }

  @override
  Map<String, dynamic>? getLocation() {
    final data = _locationBox?.get(selectedLocationKey);
    return data?.cast<String, dynamic>();
  }

  static const String profileImageKey = 'profile_image';

  @override
  Future<void> saveProfileImage(String path) async {
    await _settingsBox?.put(profileImageKey, path);
    logger('Saved profile image path to cache: $path');
  }

  @override
  String? getProfileImage() {
    return _settingsBox?.get(profileImageKey);
  }

  @override
  CustomerModel? getUserModel() {
    final user = _userBox?.get(currentUserKey);
    if (user != null) {
    }
    return user;
  }

  @override
  Future<void> clearUserModel() async {
    await _userBox?.delete(currentUserKey);
  }

  @override
  Future updateCachedUserModel(CustomerModel user) async {
    await _userBox?.put(currentUserKey, user);
    logger('Updated user in cache: ${user.toJson()}');
  }


  Future<void> _cachePage<T>(List<T> items, {String? cacheKey}) async {
    final box = await Hive.openBox<T>(cacheKey!);
    await box.putAll(items.asMap());
  }

  Future<List<T>> _getCachedPage<T>({String? cacheKey}) {
    throw UnimplementedError();
  }
  @override
  Future<void> cacheOrderId(String orderId) async {
    await _orderBox?.put('current_order_id', orderId);
  }

  @override
  Future<void> upDateOrderId(String orderId) async {
    await _orderBox?.put('current_order_id', orderId);
  }
  @override
  String? getOrderId() {
    return _orderBox?.get('current_order_id');
  }

  // New methods for delivery addition
  static const String deliveryAdditionKey = 'delivery_addition';

  Future<void> cacheDeliveryAddition(AreasModel area) async {
    await _selectedAreaBox?.put(deliveryAdditionKey, area);
    logger('Cached delivery addition area: ${area.districtName}');
  }

  AreasModel? getDeliveryAddition() {
    return _selectedAreaBox?.get(deliveryAdditionKey);
  }

  Future<void> clearDeliveryAddition() async {
    await _selectedAreaBox?.delete(deliveryAdditionKey);
  }

  @override
  Future<void> saveLocation({
    required String address,
    String? districtName,
    String? regionName,
    String? addressNotes,
    double? latitude,
    double? longitude,
  }) async {
    await _locationBox?.put(selectedLocationKey, {
      'address': address,
      'districtName': districtName,
      'regionName': regionName,
      'addressNotes': addressNotes,
      'latitude': latitude,
      'longitude': longitude,
    });
    logger('Saved location to cache: $districtName, $regionName');
  }
}
