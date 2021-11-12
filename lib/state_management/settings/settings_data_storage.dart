import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsDataStorage {
  const SettingsDataStorage(this.secureStorage);
  final FlutterSecureStorage secureStorage;

  Future<void> saveBoolState(String key, bool bool) async {
    await secureStorage.write(key: key, value: bool.toString());
  }

  Future<bool?> loadBoolState(String key) async {
    final boolValue = await secureStorage.read(key: key);
    if (boolValue == null) {
      return null;
    } else {
      return boolValue == 'true' ? true : false;
    }
  }
}
