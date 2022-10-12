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

  Future<void> writeUsernameOfflineData(String data) async {
    await secureStorage.write(key: OfflineDataKey.username, value: data);
  }

  Future<String> readUsernameOfflineData() async {
    final usernameData =
        await secureStorage.read(key: OfflineDataKey.username) ?? '';
    return usernameData;
  }

  Future<void> writeRecipientsOfflineData(String data) async {
    await secureStorage.write(key: OfflineDataKey.recipients, value: data);
  }

  Future<String> readRecipientsOfflineData() async {
    final recipientData =
        await secureStorage.read(key: OfflineDataKey.recipients) ?? '';
    return recipientData;
  }

  Future<void> writeDomainOptionsOfflineData(String data) async {
    await secureStorage.write(key: OfflineDataKey.domainOptions, value: data);
  }

  Future<String> readDomainOptionsOfflineData() async {
    final domainOptionsData =
        await secureStorage.read(key: OfflineDataKey.domainOptions) ?? '';
    return domainOptionsData;
  }

  Future<void> writeDomainOfflineData(String data) async {
    await secureStorage.write(key: OfflineDataKey.domain, value: data);
  }

  Future<String> readDomainOfflineData() async {
    final domainData =
        await secureStorage.read(key: OfflineDataKey.domain) ?? '';
    return domainData;
  }

  Future<void> writeRulesOfflineData(String data) async {
    await secureStorage.write(key: OfflineDataKey.rules, value: data);
  }

  Future<String> readRulesOfflineData() async {
    final domainData =
        await secureStorage.read(key: OfflineDataKey.rules) ?? '';
    return domainData;
  }

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
