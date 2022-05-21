import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/models/profile/profile.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class StartupMethods {
  /// Initializes [Hive] and its adapters.
  static Future<void> initHiveAdapters() async {
    try {
      await Hive.initFlutter();

      Hive.registerAdapter(AliasAdapter());
      Hive.registerAdapter(RecipientAdapter());
      Hive.registerAdapter(ProfileAdapter());
    } catch (error) {
      return;
    }
  }

  /// Does housekeeping after app is updated. Does nothing otherwise.
  static Future<void> handleAppUpdate() async {
    const secureStorage = FlutterSecureStorage();

    /// Fetch stored old app version from device storage.
    final oldAppVersion = await _getOldAppVersion(secureStorage);

    /// Fetch stored current app version from device storage.
    final currentAppVersion = await _getCurrentAppVersion();

    /// If no current app version found, exit method.
    if (currentAppVersion == null) {
      return;
    } else {
      /// Saves current AppVersion's number to acknowledge that the user
      /// has opened app with this version before.
      await _saveCurrentAppVersion(secureStorage, currentAppVersion);
    }

    /// Number NOT matching means app has been updated.
    if (oldAppVersion != currentAppVersion) {
      /// delete changelog value from the storage so that [ChangelogWidget] is displayed
      await _deleteChangelog(secureStorage);

      /// Deletes stored offline data after an app has been updated.
      /// This is to prevent bugs that may arise from conflicting stored data scheme.
      await _deleteOfflineData(secureStorage);
    }
  }

  static Future<String?> _getCurrentAppVersion() async {
    try {
      final appVersion = await PackageInfo.fromPlatform();
      return appVersion.version;
    } catch (error) {
      return null;
    }
  }

  static Future<void> _saveCurrentAppVersion(
      FlutterSecureStorage secureStorage, String currentAppVersion) async {
    try {
      await secureStorage.write(
        key: ChangelogStorageKey.appVersionKey,
        value: currentAppVersion,
      );
    } catch (error) {
      return;
    }
  }

  static Future<String?> _getOldAppVersion(
      FlutterSecureStorage secureStorage) async {
    try {
      const key = ChangelogStorageKey.appVersionKey;
      final version = await secureStorage.read(key: key);
      return version;
    } catch (error) {
      return null;
    }
  }

  static Future<void> _deleteChangelog(
      FlutterSecureStorage secureStorage) async {
    try {
      await secureStorage.delete(key: ChangelogStorageKey.changelogKey);
    } catch (error) {
      return;
    }
  }

  static Future<void> _deleteOfflineData(
      FlutterSecureStorage secureStorage) async {
    try {
      await secureStorage.delete(key: OfflineDataKey.aliases);
      await secureStorage.delete(key: OfflineDataKey.account);
      await secureStorage.delete(key: OfflineDataKey.username);
      await secureStorage.delete(key: OfflineDataKey.recipients);
      await secureStorage.delete(key: OfflineDataKey.domainOptions);
      await secureStorage.delete(key: OfflineDataKey.domain);
      await secureStorage.delete(key: OfflineDataKey.rules);
    } catch (error) {
      return;
    }
  }
}
