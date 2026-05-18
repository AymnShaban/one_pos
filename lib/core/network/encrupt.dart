import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../local/hive_service_impl.dart';
import '../services/service_locator/services_imports.dart';



final basicToken = 'Basic ${getIt<HiveServiceImpl>().getAuthorization()??""}';
final privateKey =  getIt<HiveServiceImpl>().getPrivateKey()??"";
final publicKey = getIt<HiveServiceImpl>().getPublicKey()??"";


dynamic decrypt(String encryptedText) {
  final keyObj = encrypt.Key.fromUtf8(privateKey);
  final ivObj = encrypt.IV.fromUtf8(publicKey);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(keyObj, mode: encrypt.AESMode.cbc),
  );

  try {
    final decrypted = encrypter.decrypt(
      encrypt.Encrypted.fromBase64(encryptedText),
      iv: ivObj,
    );
    return decrypted;
  } catch (e) {
    return 'Error....................';
  }
}

String encryptData(
  Map<String, dynamic> data,
) {
  final key = encrypt.Key.fromUtf8(privateKey);
  final iv = encrypt.IV.fromUtf8(publicKey);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc),
  );
  try {
    String jsonString = json.encode(data);
    final encrypted = encrypter.encrypt(jsonString, iv: iv);
    final encryptedText = encrypted.base64;
    return encryptedText;
  } catch (e) {
    return 'Error....................';
  }
}
