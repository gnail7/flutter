import 'dart:convert';
import 'dart:typed_data';
import 'package:basic_utils/basic_utils.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/api.dart';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/asymmetric/rsa.dart';

RSAPublicKey loadPublicKeyByStr(String publicKeyStr) {
  // 1. base64 decode
  final publicKeyBytes = base64Decode(publicKeyStr);

  // 2. 解析 X.509 公钥结构（ASN.1）
  final asn1Parser = ASN1Parser(publicKeyBytes);
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

  // 3. 取出 BIT STRING（真正的公钥结构）
  final publicKeyBitString = topLevelSeq.elements[1] as ASN1BitString;

  final publicKeyAsn = ASN1Parser(publicKeyBitString.contentBytes()!);
  final publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;

  // 4. 解析 modulus(N) 和 exponent(E)
  final modulus = publicKeySeq.elements[0] as ASN1Integer;
  final exponent = publicKeySeq.elements[1] as ASN1Integer;

  // 5. 返回 Dart 的 RSAPublicKey
  return RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
}

String rsaEncryptNoPadding(String plainText, RSAPublicKey publicKey) {
  final engine = RSAEngine() // 无填充
    ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

  final data = utf8.encode(plainText);
  final keySize = (publicKey.modulus!.bitLength + 7) >> 3; // bytes

  if (data.length > keySize) {
    throw Exception('Plaintext too long for RSA key without padding');
  }

  // 如果明文长度 < keySize，需要自己补零到 keySize
  final padded = Uint8List(keySize);
  padded.setRange(keySize - data.length, keySize, data);

  final encrypted = engine.process(padded);

  return base64Encode(encrypted);
}


String derToPem(String derBase64) {
  // 添加 PEM 头尾
  final pem = StringBuffer();
  pem.writeln('-----BEGIN PUBLIC KEY-----');

  // 每 64 个字符换行
  for (int i = 0; i < derBase64.length; i += 64) {
    int end = (i + 64 < derBase64.length) ? i + 64 : derBase64.length;
    pem.writeln(derBase64.substring(i, end));
  }

  pem.writeln('-----END PUBLIC KEY-----');
  return pem.toString();
}


RSAPublicKey parsePemPublicKey(String pem) {
  final parser = RSAKeyParser();

  return parser.parse(pem) as RSAPublicKey;
}



