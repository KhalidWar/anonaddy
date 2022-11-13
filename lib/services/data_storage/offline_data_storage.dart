import 'package:anonaddy/shared_components/constants/changelog_storage_key.dart';
import 'package:anonaddy/shared_components/constants/offline_data_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final flutterSecureStorage = Provider((ref) => const FlutterSecureStorage());

final offlineDataProvider = Provider<OfflineData>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  return OfflineData(secureStorage);
});

class OfflineData {
  OfflineData(this.secureStorage);
  final FlutterSecureStorage secureStorage;

  Future<void> saveSettingsState(String data) async {
    try {
      await secureStorage.write(key: OfflineDataKey.settings, value: data);
    } catch (error) {
      rethrow;
    }
  }

  Future<String> loadSettingsState() async {
    try {
      final aliasData =
          await secureStorage.read(key: OfflineDataKey.settings) ?? '';
      return aliasData;
    } catch (error) {
      rethrow;
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
