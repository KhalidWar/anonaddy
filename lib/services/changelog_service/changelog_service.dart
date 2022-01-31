import 'package:anonaddy/shared_components/constants/changelog_storage_key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ChangelogService {
  ChangelogService(this.secureStorage);
  final FlutterSecureStorage secureStorage;

  Future<String?> getChangelogStatus() async {
    final status =
        await secureStorage.read(key: ChangelogStorageKey.changelogKey);
    return status;
  }

  /// Marks [Changelog] as read so it doesn't show it again on app restart
  Future<void> markChangelogRead() async {
    await secureStorage.write(
        key: ChangelogStorageKey.changelogKey, value: false.toString());
  }

  /// Deletes/resets changelogKey (status) from storage
  Future<void> deleteChangelogStatus() async {
    await secureStorage.delete(key: ChangelogStorageKey.changelogKey);
  }

  /// Save current [AppVersion] version number
  Future<void> saveCurrentAppVersion(String currentVersion) async {
    await secureStorage.write(
        key: ChangelogStorageKey.appVersionKey, value: currentVersion);
  }

  Future<String> loadOldAppVersion() async {
    return await secureStorage.read(key: ChangelogStorageKey.appVersionKey) ??
        '';
  }

  Future<String> getCurrentAppVersion() async {
    final appVersion = await PackageInfo.fromPlatform();
    return appVersion.version;
  }
}
