import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;

//test
// final basicToken = 'Basic ZTBjOWRlMWIyZGUyNmZlMjpnOEV0eXg4VFU1Nzl2RHhKemFOMWxvM3I0NitXSkx2cWIvSU1ZZElVUkhNPQ==';
// final privateKey = 'c104780a25b4f80c037445dd1f6947e1';
// final publicKey = 'e0c9de1b2de26fe2';

// mazyad
final basicToken =
    'Basic MTE5MTEyODE2MzRlYjVhYTpTZk12SU1FNTlOU05qZEVsdlpqK2NDM0ZuaUJBWTBxRGlSM2xqVnU0RU5ZPQ==';
final privateKey = '7a0847a8ed338cff77b74bc74a8061de';
final publicKey = '11911281634eb5aa';


//  // alharamayn
// final basicToken =
//     'Basic NzNhZDlkN2U4MzI4OWVlNzpaSEltUG5KNXNXUWt5bWFtQm45WnNyeFhuYzRHcWp0SVhIOFZMN0FtWVBRPQ==';
// final privateKey = '6eaceaec3d66b72db1c0f7c694b963ba';
// final publicKey = '73ad9d7e83289ee7';

dynamic decrypt(String encryptedText, String privateKey, String publicKey) {
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
  String privateKey,
  String publicKey,
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
