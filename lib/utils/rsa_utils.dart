import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RsaUtils {
  static String encrypt(String text, String publicKeyStr) {
    final publicKey = RSAKeyParser().parse(publicKeyStr) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey));
    return encrypter.encrypt(text).base64;
  }
}
