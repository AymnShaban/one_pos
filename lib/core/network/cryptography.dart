import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';

const String hmacSecret =
    "ZTBjOWRlMWIyZGUyNmZlMjpnOEV0eXg4VFU1Nzl2RHhKemFOMWxvM3I0NitXSkx2cWIvSU1ZZElVUkhNPQ==";

const String aesGcmKey = "NewNewNewHello12";

class SignedHeaders {
  final String timestamp;
  final String signature;
  final String clientKey;

  const SignedHeaders({
    required this.timestamp,
    required this.signature,
    required this.clientKey,
  });

  Map<String, String> toMap() => {
        'X-Timestamp': timestamp,
        'X-Signature': signature,
        'X-Client-Key': clientKey,
      };
}

SignedHeaders signRequest(String body) {
  final timestamp =
      (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  final payload = body + timestamp;
  final hmac = crypto.Hmac(crypto.sha256, utf8.encode(hmacSecret));
  final digest = hmac.convert(utf8.encode(payload));
  return SignedHeaders(
    timestamp: timestamp,
    signature: base64Encode(digest.bytes),
    clientKey: hmacSecret,
  );
}

Future<String> decryptAesGcm(String base64Data) async {
  final data = base64Decode(base64Data.trim());

  final nonce = data.sublist(0, 12);
  final tag = data.sublist(12, 28);
  final cipherText = data.sublist(28);

  final secretKey = SecretKey(utf8.encode(aesGcmKey));
  final algorithm = AesGcm.with128bits();

  final secretBox = SecretBox(
    cipherText,
    nonce: nonce,
    mac: Mac(tag),
  );

  final clearText = await algorithm.decrypt(
    secretBox,
    secretKey: secretKey,
  );

  return utf8.decode(clearText);
}
