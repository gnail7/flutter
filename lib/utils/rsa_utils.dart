import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/asn1.dart';

class CryptoUtil {
  /// Uint8List → BigInt
  static BigInt _bytesToBigInt(Uint8List bytes) {
    return BigInt.parse(
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      radix: 16,
    );
  }

  /// 解析 X.509 公钥
  static RSAPublicKey parseX509PublicKey(Uint8List keyBytes) {
    final asn1Parser = ASN1Parser(keyBytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    final bitString = topLevelSeq.elements![1] as ASN1BitString;
    final pubKeyBytes = Uint8List.fromList(bitString.stringValues!);

    final pubKeyParser = ASN1Parser(pubKeyBytes);
    final publicKeySeq = pubKeyParser.nextObject() as ASN1Sequence;

    final modulusBytes = (publicKeySeq.elements![0] as ASN1Integer).valueBytes!;
    final exponentBytes = (publicKeySeq.elements![1] as ASN1Integer).valueBytes!;

    final modulus = _bytesToBigInt(modulusBytes);
    final exponent = _bytesToBigInt(exponentBytes);

    return RSAPublicKey(modulus, exponent);
  }

  /// RSA 分段加密
  static String encrypt(Uint8List keyBytes, String src) {
    try {
      // 1. UTF-8 转字节
      final data = utf8.encode(src);

      // 2. 解析公钥
      final publicKey = parseX509PublicKey(keyBytes);
      print('modulus: ${publicKey.modulus}');
      print('exponent: ${publicKey.exponent}');
      // 3. PKCS1Padding RSA Engine
      final cipher = PKCS1Encoding(RSAEngine())..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

      // 4. 分段加密（与 Java Cipher blockSize / outputSize 逻辑一致）
      final blockSize = cipher.inputBlockSize;
      final outputSize = cipher.outputBlockSize;

      final leavedSize = data.length % blockSize;
      final blocksSize = leavedSize != 0 ? (data.length ~/ blockSize) + 1 : data.length ~/ blockSize;
      final raw = Uint8List(outputSize * blocksSize);

      int offset = 0;
      for (int i = 0; i < blocksSize; i++) {
        final start = i * blockSize;
        final end = (start + blockSize < data.length) ? start + blockSize : data.length;
        final block = data.sublist(start, end);

        final encryptedBlock = cipher.process(Uint8List.fromList(block));
        raw.setRange(i * outputSize, i * outputSize + encryptedBlock.length, encryptedBlock);

        offset += block.length;
      }

      // 5. Base64 输出
      return base64.encode(raw);
    } catch (e, s) {
      print("Error encrypt RSA: $e\n$s");
      return "";
    }
  }
}
