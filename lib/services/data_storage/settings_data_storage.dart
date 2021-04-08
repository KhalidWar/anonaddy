import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsDataStorage {
  final _secureStorage = FlutterSecureStorage();

  Future<void> saveBoolState(String key, bool bool) async {
    await _secureStorage.write(key: key, value: bool.toString());
  }

  Future<bool> loadBoolState(String key) async {
    return await _secureStorage.read(key: key).then((value) {
      return value == 'true' ? true : false;
    });
  }
}
