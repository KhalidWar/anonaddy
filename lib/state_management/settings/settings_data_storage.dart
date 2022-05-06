import 'package:anonaddy/global_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final settingsDataStorageProvider = Provider<SettingsDataStorage>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  return SettingsDataStorage(secureStorage: secureStorage);
});

class SettingsDataStorage {
  const SettingsDataStorage({required this.secureStorage});
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
