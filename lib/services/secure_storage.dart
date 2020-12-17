import 'package:flutter_riverpod/all.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider((ref) => SecureStorage());

class SecureStorage {
  final _secureStorage = FlutterSecureStorage();
  final _accessTokenKey = 'accessToken';

  Future<void> saveAccessToken(String value) async {
    await _secureStorage.write(key: _accessTokenKey, value: value);
  }

  Future<String> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }
}
