import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info/package_info.dart';

class ChangelogService {
  const ChangelogService(this.secureStorage);
  final FlutterSecureStorage secureStorage;

  final _changelogKey = 'changelogKey';
  final _appVersionKey = 'appVersionKey';

  Future<bool> isAppUpdated() async {
    return await secureStorage.read(key: _changelogKey).then((value) {
      if (value == 'true' || value == null) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<void> dismissChangeLog() async {
    await secureStorage.write(key: _changelogKey, value: false.toString());
  }

  Future<String> _getCurrentAppVersion() async {
    final appVersion = await PackageInfo.fromPlatform();
    return appVersion.version;
  }

  Future<String> _loadOldAppVersion() async {
    return await secureStorage.read(key: _appVersionKey) ?? '';
  }

  Future<void> _saveCurrentAppVersion(String currentVersion) async {
    await secureStorage.write(key: _appVersionKey, value: currentVersion);
  }

  Future<void> checkIfAppUpdated(BuildContext context) async {
    final oldAppVersion = await _loadOldAppVersion();
    final currentAppVersion = await _getCurrentAppVersion();
    if (oldAppVersion != currentAppVersion) {
      await secureStorage.delete(key: _changelogKey);
      await _saveCurrentAppVersion(currentAppVersion);
    }
  }
}
