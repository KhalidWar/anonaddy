import 'package:anonaddy/common/constants/changelog_storage_key.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final secureStorage = ref.read(flutterSecureStorageProvider);
  return SettingsRepository(secureStorage);
});

class SettingsRepository {
  const SettingsRepository(this.secureStorage);

  final FlutterSecureStorage secureStorage;

  static const _settings = 'settingsDataKey';

  Future<void> saveSettingsState(String data) async {
    try {
      await secureStorage.write(key: _settings, value: data);
    } catch (error) {
      rethrow;
    }
  }

  Future<String?> loadSettingsState() async {
    try {
      final aliasData = await secureStorage.read(key: _settings);
      if (aliasData == null) return null;
      return aliasData;
    } catch (error) {
      return null;
    }
  }

  Future<void> saveCurrentAppVersion(String currentAppVersion) async {
    try {
      await secureStorage.write(
        key: ChangelogStorageKey.appVersionKey,
        value: currentAppVersion,
      );
    } catch (error) {
      return;
    }
  }
}
