import 'package:hive_flutter/hive_flutter.dart';
import 'package:one_pos/feature/auth/models/user_model.dart';
import '../../feature/auth/models/areas_model.dart';
import '../../feature/barren/domain/entities/invoice_product.dart';
import '../../feature/main/basket/basket_imports.dart';
import '../entity/barren_invoice_model.dart';
import '../helper/logger.dart';
import '../models/item_model.dart';
part 'user_cache_interface.dart';
part 'paginated_cache_interface.dart';
part 'invoice_cache.dart';

class HiveServiceImpl implements IUserCache, IBasket , InvoiceCache {
  static const String userBoxName = 'user_box';
  static Box<UserModel>? _userBox;
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
  static const String basketBoxName      = 'basket_box';
  // Invoice cache
  static const String invoiceBoxName = 'invoice_box';
  static Box<BarrenInvoiceModel>? _invoiceBox;
  static const String currentInvoiceKey = 'current_invoice';

  static Box<ItemModel>? _basketBox;
  HiveServiceImpl._();

  static final HiveServiceImpl instance = HiveServiceImpl._();

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ItemModelAdapter());
    Hive.registerAdapter(AreasModelAdapter());
    // Barren stock-taking persistence
    Hive.registerAdapter(InvoiceProductAdapter());
    Hive.registerAdapter(BarrenInvoiceModelAdapter());

    _userBox = await _openBoxSafely<UserModel>(userBoxName);
    _orderBox = await _openBoxSafely<String>(orderBoxName);
    _selectedAreaBox = await _openBoxSafely<AreasModel>(selectedAreaBoxName);
    _locationBox = await _openBoxSafely<Map>(locationBoxName);
    _settingsBox = await _openBoxSafely(settingsBoxName);
    _basketBox = await _openBoxSafely<ItemModel>(basketBoxName);
    _invoiceBox = await _openBoxSafely<BarrenInvoiceModel>(invoiceBoxName);
  }

  /// Opens a Hive box, recovering from data written with an incompatible
  /// adapter schema (e.g. UserModel changed but kept typeId 0). If decoding
  /// the persisted data throws, the stale box is deleted from disk and
  /// reopened empty so the app can still start (the user just logs in again).
  static Future<Box<T>> _openBoxSafely<T>(String name) async {
    try {
      return await Hive.openBox<T>(name);
    } catch (e) {
      logger('Hive box "$name" is incompatible ($e). Recreating it.');
      await Hive.deleteBoxFromDisk(name);
      return await Hive.openBox<T>(name);
    }
  }

  @override
  Future<void> cacheUserModel(UserModel user) async {
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
  UserModel? getUserModel() {
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
  Future updateCachedUserModel(UserModel user) async {
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

  Future<void> saveActivationCode(String code) async {
    await _settingsBox?.put(_activationCodeKey, code);
    await _settingsBox?.flush();
  }

  String? getActivationCode() {
    final value = _settingsBox?.get(_activationCodeKey);
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  Future<void> saveAppConfig(Map<String, dynamic> config) async {
    await _settingsBox?.put(_appConfigKey, config);
    await _settingsBox?.flush();
  }

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

  Future<void> saveUserId(int id) async {
    await _settingsBox?.put(_userIdKey, id);
    await _settingsBox?.flush();
  }

  int? getUserId() => _settingsBox?.get(_userIdKey);

  Future<void> saveSellerName(String name) async =>
      await _settingsBox?.put(_sellerNameKey, name);

  String? getSellerName() => _settingsBox?.get(_sellerNameKey);

  Future<void> saveHaveDiscount(int value) async =>
      await _settingsBox?.put(_haveDiscountKey, value);

  int getHaveDiscount() => _settingsBox?.get(_haveDiscountKey) ?? 1;

  // ── Auth config getters (from ActivationModel saved at activation) ─────────
  String? getPrivateKey() {
    final config = getAppConfig();
    return config?['PrivateKey'] as String?;
  }

  String? getPublicKey() {
    final config = getAppConfig();
    return config?['PublicKey'] as String?;
  }

  String? getAuthorization() {
    final config = getAppConfig();
    return config?['Authorization'] as String?;
  }

  String? getBaseUrl() {
    final config = getAppConfig();
    return config?['BaseURL'] as String?;
  }

  String? getIpAddress() {
    final config = getAppConfig();
    return config?['Server'] as String?;
  }

  String? getServerUserName() {
    final config = getAppConfig();
    return config?['UserName'] as String?;
  }

  String? getServerPassword() {
    final config = getAppConfig();
    return config?['PassWord'] as String?;
  }

  String? getDatabaseName() {
    final config = getAppConfig();
    return config?['DBDescription'] as String?;
  }

  // --- IBasket Implementation ---

  @override
  Future<void> saveBasketItem(ItemModel item) async {
    // Check if item already exists in basket by productID and barCode
    final existingIndex = _basketBox?.values.toList().indexWhere(
      (element) => element.productId == item.productId && element.barCode == item.barCode
    );

    if (existingIndex != null && existingIndex != -1) {
      final existingItem = _basketBox?.getAt(existingIndex);
      if (existingItem != null) {
        // If it exists, increment the quantity by 1
        await _basketBox?.putAt(existingIndex, existingItem.copyWith(
          salesQuantity: existingItem.salesQuantity + 1,
        ));
      }
    } else {
      // If it doesn't exist, add it with salesQuantity 1
      await _basketBox?.add(item.copyWith(salesQuantity: 1));
    }
  }

  @override
  Future<void> setBasketItemQuantity(ItemModel item, int quantity) async {
    final existingIndex = _basketBox?.values.toList().indexWhere(
      (element) =>
          element.productId == item.productId &&
          element.barCode == item.barCode,
    );

    if (quantity <= 0) {
      if (existingIndex != null && existingIndex != -1) {
        await _basketBox?.deleteAt(existingIndex);
      }
      return;
    }

    if (existingIndex != null && existingIndex != -1) {
      await _basketBox?.putAt(
        existingIndex,
        item.copyWith(salesQuantity: quantity),
      );
    } else {
      await _basketBox?.add(item.copyWith(salesQuantity: quantity));
    }
  }

  @override
  Future<List<ItemModel>> getBasketItems() async {
    return _basketBox?.values.toList() ?? [];
  }

  @override
  Future<void> deleteBasketItem(int productId, String barCode) async {
    final existingIndex = _basketBox?.values.toList().indexWhere(
      (element) => element.productId == productId && element.barCode == barCode
    );

    if (existingIndex != null && existingIndex != -1) {
      // Check if quantity > 1, decrement it. If 1, remove it.
      final item = _basketBox?.getAt(existingIndex);
      if (item != null) {
        if (item.salesQuantity > 1) {
           await _basketBox?.putAt(existingIndex, item.copyWith(salesQuantity: item.salesQuantity - 1));
        } else {
           await _basketBox?.deleteAt(existingIndex);
        }
      }
    }
  }

  @override
  Future<void> updateBasketItem(ItemModel item) async {
    final existingIndex = _basketBox?.values.toList().indexWhere(
      (element) =>
          element.productId == item.productId &&
          element.barCode == item.barCode,
    );

    if (existingIndex != null && existingIndex != -1) {
      await _basketBox?.putAt(existingIndex, item);
    }
  }

  @override
  Future<void> clearBasket() async {
    await _basketBox?.clear();
  }


  // --- IInvoiceCache Implementation ---

  @override
  Future<void> cacheInvoice(BarrenInvoiceModel invoice) async {
    await _invoiceBox?.put(currentInvoiceKey, invoice);
    logger('Cached barren invoice with ${invoice.products.length} items');
  }

  @override
  BarrenInvoiceModel? getInvoice() {
    return _invoiceBox?.get(currentInvoiceKey);
  }

  @override
  Future<void> clearInvoice() async {
    await _invoiceBox?.delete(currentInvoiceKey);
    logger('Cleared cached invoice');
  }

}
