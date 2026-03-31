//
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class SecureStorageService {
//   static var _storage =   FlutterSecureStorage();
//
//   static const String token = "token";
//   static const String mobile = "mobile";
//   static const String email = "email";
//   static const String name = "name";
//   static const String photo="photo";
//   static const String adress="address";
//   static const String vilanumber="vilanumber";
//   static const String villaSpace="villaSpace";
//   static const String vilalocation="vilalocation";
//   static const String villaStreet="villaStreet";
//   static const String villaFloorsNumber="villaFloorsNumber";
//
//   static Future<void> write(dynamic key, String value) async {
//     await _storage.write(key: key.toString(), value: value);
//   }
//
//   static Future<String?> read(dynamic key) async {
//     return await _storage.read(key: key.toString());
//   }
//
//   static Future<void> delete(dynamic key) async {
//     await _storage.delete(key: key.toString());
//   }
//
//   static Future<bool> containsKey(dynamic key) async {
//     return await _storage.containsKey(key: key.toString());
//   }
//   static Future<void> clearSavedKeys() async {
//     List<String> keys = [
//       token,
//       mobile,
//       email,
//       name,
//       photo,
//       adress,
//       vilanumber,
//       villaSpace,
//       vilalocation,
//       villaStreet,
//       villaFloorsNumber,
//     ];
//
//     for (var key in keys) {
//       await _storage.delete(key: key);
//     }
//   }
//
//   static Future<void> clearAll() async {
//     await _storage.deleteAll();
//   }
// }