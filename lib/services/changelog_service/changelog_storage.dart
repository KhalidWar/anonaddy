import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangelogStorage {
  const ChangelogStorage(this.secureStorage);
  final FlutterSecureStorage secureStorage;

  static const _changelogKey = 'changelogKey';
  static const _appVersionKey = 'appVersionKey';

  Future<String?> getChangelogStatus() async {
    final status = await secureStorage.read(key: _changelogKey);
    return status;
  }

  /// Marks [Changelog] as read so it doesn't show it again on app restart
  Future<void> markChangelogRead() async {
    await secureStorage.write(key: _changelogKey, value: false.toString());
  }

  /// Deletes/resets changelogKey (status) from storage
  Future<void> deleteChangelogStatus() async {
    await secureStorage.delete(key: _changelogKey);
  }

  Future<String> loadOldAppVersion() async {
    return await secureStorage.read(key: _appVersionKey) ?? '';
  }

  /// Save current [AppVersion] version number
  Future<void> saveCurrentAppVersion(String currentVersion) async {
    await secureStorage.write(key: _appVersionKey, value: currentVersion);
  }
}
