import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RsaUtils {
  static String encrypt(String text, String publicKeyStr) {
    // 如果没有 PEM 头，则自动加
    if (!publicKeyStr.contains('BEGIN PUBLIC KEY')) {
      publicKeyStr = """
-----BEGIN PUBLIC KEY-----
$publicKeyStr
-----END PUBLIC KEY-----
""";
    }

    final publicKey = RSAKeyParser().parse(publicKeyStr) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    return encrypter.encrypt(text).base64;
  }
}
