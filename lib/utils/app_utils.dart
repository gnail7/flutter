import 'dart:convert';
import 'dart:typed_data';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart' as pc;

String rsaEncryptJavaCompatible(Uint8List publicKeyBytes, String plainText) {
  try {
    // 解析 X509 公钥
    final parser = ASN1Parser(publicKeyBytes);
    final topLevelSeq = parser.nextObject() as ASN1Sequence;
    final publicKeyBitString = topLevelSeq.elements![1] as ASN1BitString;
    final publicKeyAsn1 =
    ASN1Parser(publicKeyBitString.contentBytes()!).nextObject() as ASN1Sequence;

    final modulus = (publicKeyAsn1.elements![0] as ASN1Integer).valueAsBigInteger;
    final exponent = (publicKeyAsn1.elements![1] as ASN1Integer).valueAsBigInteger;
    final rsaPublicKey = pc.RSAPublicKey(modulus, exponent);
    final cipher = pc.PKCS1Encoding(pc.RSAEngine());
    cipher.init(true, pc.PublicKeyParameter<pc.RSAPublicKey>(rsaPublicKey));

    final data = utf8.encode(plainText);

    ///  能分多少块
    final keySize = (rsaPublicKey.modulus!.bitLength + 7) ~/ 8;
    final blockSize = keySize - 11; // PKCS1 填充块大小
    final outputSize = keySize;

    final raw = Uint8List(outputSize * ((data.length + blockSize - 1) ~/ blockSize));
    int rawOffset = 0;

    for (int i = 0; i < data.length; i += blockSize) {
      final end = (i + blockSize < data.length) ? i + blockSize : data.length;
      final chunk = Uint8List.fromList(data.sublist(i, end));
      final encryptedChunk = cipher.process(chunk);
      raw.setRange(rawOffset, rawOffset + encryptedChunk.length, encryptedChunk);
      rawOffset += encryptedChunk.length;
    }

    return base64Encode(raw);
  } catch (e) {
    throw Exception("RSA 加密失败: $e");
  }
}
