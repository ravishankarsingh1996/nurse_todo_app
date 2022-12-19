import 'package:encrypt/encrypt.dart';

class EncryptData {
  late final Key key;
  late final IV iv;

  EncryptData() {
    key = Key.fromLength(32);
    iv = IV.fromLength(8);
  }

  String encryptData(String data) {
    final encryptor = Encrypter(AES(key, padding: null));
    final encrypted = encryptor.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  String decryptData(String data) {
    final encryptor = Encrypter(AES(key, padding: null));
    final decrypted = encryptor.decrypt(Encrypted.from64(data), iv: iv);
    return decrypted;
  }
}
