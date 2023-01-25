
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rncryptor/rncryptor.dart';

void main() {

  test('encrypt & decrypt - with sample string', () {
    // given
    String plainText = "This is a sample string";
    String password = "1234567890abcdef";

    String result = RNCryptor.encrypt(password, plainText);
    print(result);

    String? result2 = RNCryptor.decrypt(password, result);

    // then
    expect(result2, isNot(null));
    expect(result2, equals(plainText));
  });

  test('encryptData & decryptData - with sample string', () {
    // given
    String plainText = "This is a sample string";
    Uint8List plainData = Uint8List.fromList(utf8.encode(plainText));
    String password = "1234567890abcdef";

    Uint8List result = RNCryptor.encryptData(password, plainData);
    print(base64.encode(result));

    Uint8List? result2 = RNCryptor.decryptData(password, result);

    // then
    expect(result2, isNot(null));
    String resultText = utf8.decode(result2!.toList());
    print(resultText);

    expect(resultText, equals(plainText));
  });

  test('encryptData & decryptData - with sample string', () {
    // given
    String plainText = "This is a sample string";
    Uint8List plainData = Uint8List.fromList(utf8.encode(plainText));
    String password = "1234567890abcdef";

    Uint8List result = RNCryptor.encryptData(password, plainData);
    print(base64.encode(result));

    Uint8List? result2 = RNCryptor.decryptData(password, result);

    // then
    expect(result2, isNot(null));
    String resultText = utf8.decode(result2!.toList());
    print(resultText);

    expect(resultText, equals(plainText));
  });

  test('encryptData & decryptData - with random bytes',() {

    // given
    String password = "1234567890abcdef";
    Uint8List plainData = generateRandomByte();
    String base64plainData = base64.encode(plainData);

    Uint8List result = RNCryptor.encryptData(password, plainData);
    print(base64.encode(result));

    Uint8List? result2 = RNCryptor.decryptData(password, result);

    // then
    expect(result2, isNot(null));

    String base64Result2 = base64.encode(result2!);

    // then
    expect(base64plainData, equals(base64Result2));

  });

  test('encryptData & decryptData on file should work',() async {

    // given
    String password = "1234567890abcdef";
    File inputFile = File("test/file_encryption_test.png");
    File outputFile = File("test/file_encryption_test_decrypted.png");

    Uint8List filebyte = await inputFile.readAsBytes();

    Uint8List result = RNCryptor.encryptData(password, filebyte);

    Uint8List? result2 = RNCryptor.decryptData(password, result);

    // save decrypted file
    await outputFile.writeAsBytes(result2!);

    // then
    expect(inputFile.lengthSync(), equals(outputFile.lengthSync()));
  });

  test('encryptData & decryptData on file with wrong password should produce null',() async {

    // given
    String password = "1234567890abcdef";
    File inputFile = File("test/file_encryption_test.png");
    File outputFile = File("test/file_encryption_test_decrypted.png");
    String wrongPassword = "qwertyuiop0987654321";

    Uint8List filebyte = await inputFile.readAsBytes();

    Uint8List result = RNCryptor.encryptData(password, filebyte);

    Uint8List? result2 = RNCryptor.decryptData(wrongPassword, result);

    // save decrypted file
    expect(result2, equals(null));

  });

  test('decryption on cipher file',() async {

    // given
    String cipherFilePath = "test/cipherfile.cipher";
    String outputFilePath = "test/cipherfile.png";

    File cipherFile = File(cipherFilePath);
    Uint8List cipherData = await cipherFile.readAsBytes();

    File outputFile = File(outputFilePath);
    String password = "1-63c795f6ff9738c6626c0f9f-63cf56825375780b4ffefda3";

    Uint8List? result = RNCryptor.decryptData(password.substring(0, 16), cipherData);

    // then
    expect(result, isNot(null));

    await outputFile.writeAsBytes(result!);
  });
}

Uint8List generateRandomByte([int length = 32]) {
  var values = List<int>.generate(length, (i) => Random.secure().nextInt(256));
  return Uint8List.fromList(values);
}