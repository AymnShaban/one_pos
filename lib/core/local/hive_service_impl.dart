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
  static const String _activationCodeKey = 'activation_code';
  static const String _appConfigKey      = 'app_config';
  static const String _loggedInUserKey   = 'logged_in_user';
  static const String _userIdKey         = 'user_id';
  static const String _sellerNameKey     = 'seller_name';
  static const String _haveDiscountKey   = 'have_discount';
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

  Future<void> saveActivationCode(String code) async =>
      await _settingsBox?.put(_activationCodeKey, code);

  String? getActivationCode() =>
      _settingsBox?.get(_activationCodeKey);

  Future<void> saveAppConfig(Map<String, dynamic> config) async =>
      await _settingsBox?.put(_appConfigKey, config);

  Map<String, dynamic>? getAppConfig() {
    final data = _settingsBox?.get(_appConfigKey);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  Future<void> clearAppConfig() async {
    await _settingsBox?.delete(_activationCodeKey);
    await _settingsBox?.delete(_appConfigKey);
    await _settingsBox?.delete(_loggedInUserKey);
    await _settingsBox?.delete(_userIdKey);
    await _settingsBox?.delete(_sellerNameKey);
    await _settingsBox?.delete(_haveDiscountKey);
  }

  Future<void> saveLoggedInUser(Map<String, dynamic> user) async =>
      await _settingsBox?.put(_loggedInUserKey, user);

  Map<String, dynamic>? getLoggedInUser() {
    final data = _settingsBox?.get(_loggedInUserKey);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  Future<void> saveUserId(int id) async =>
      await _settingsBox?.put(_userIdKey, id);

  int? getUserId() => _settingsBox?.get(_userIdKey);

  Future<void> saveSellerName(String name) async =>
      await _settingsBox?.put(_sellerNameKey, name);

  String? getSellerName() => _settingsBox?.get(_sellerNameKey);

  Future<void> saveHaveDiscount(int value) async =>
      await _settingsBox?.put(_haveDiscountKey, value);

  int getHaveDiscount() => _settingsBox?.get(_haveDiscountKey) ?? 1;
}
