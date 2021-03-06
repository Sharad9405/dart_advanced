import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:pointycastle/pointycastle.dart';


void main(){

  final keyBytes = _randomBytes(16);
  final key = KeyParameter(keyBytes);

  final iv = _randomBytes(8);
  final params = ParametersWithIV(key, iv);

  final cipher = StreamCipher('Salsa20');
  cipher.init(true, params);

  // Encrypt
  final plain_Text = 'Hello World';
  final plainData = _createUint8ListFromString(plain_Text);
  final encryptedData = cipher.process(plainData);

//  Decrypt
  cipher.reset();
  cipher.init(false, params);
  final decryptedData = cipher.process(encryptedData);

  _displayUint8List('Plain text', plainData);
  _displayUint8List('Encrypted Data', encryptedData);
  _displayUint8List('Decrypted Data', decryptedData);

// make sure they match
  Function eq = const ListEquality().equals;
  assert(eq(plainData, decryptedData));

  print(utf8.decode(decryptedData));






}

Uint8List _createUint8ListFromString(String value){
  return Uint8List.fromList(utf8.encode(value));
}

void _displayUint8List(String title, Uint8List value){
  print(title);
  print(value);
  print(base64.encode(value));
  print('');
}


Uint8List _randomBytes(int length){

  final rnd = SecureRandom("AES/CTR/AUTO-SEED-PRNG"); //algorithm

  final key = Uint8List(16);  // block size
  final keyParam = KeyParameter(key);
  final param = ParametersWithIV(keyParam, Uint8List(16));

  rnd.seed(param);

  final random = Random();
  for(int i = 0; i < random.nextInt(255); i++){
    rnd.nextUint8();
  }

  final bytes = rnd.nextBytes(length);
  return bytes;
}