import 'package:anonaddy/models/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app.dart';
import 'models/alias/alias.dart';
import 'models/recipient/recipient.dart';
import 'shared_components/constants/changelog_storage_key.dart';
import 'shared_components/constants/offline_data_key.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Keeps SplashScreen on until following methods are completed.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await _initHive();
  await _handleAppUpdate();

  /// Removes SplashScreen
  FlutterNativeSplash.remove();

  /// Launches app
  runApp(
    /// Phoenix restarts app upon logout
    Phoenix(
      /// Riverpod base widget to store provider state
      child: const ProviderScope(
        child: App(),
      ),
    ),
  );
}

/// Initializes [Hive] and its adapters.
Future<void> _initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(AliasAdapter());
  Hive.registerAdapter(RecipientAdapter());
  Hive.registerAdapter(ProfileAdapter());
}

/// Does housekeeping after app is updated. Does nothing otherwise.
Future<void> _handleAppUpdate() async {
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
    await secureStorage.write(
      key: ChangelogStorageKey.appVersionKey,
      value: currentAppVersion,
    );
  }

  /// Number NOT matching means app has been updated.
  if (oldAppVersion != currentAppVersion) {
    /// delete changelog value from the storage so that [ChangelogWidget] is displayed
    await secureStorage.delete(key: ChangelogStorageKey.changelogKey);

    /// Deletes stored offline data after an app has been updated.
    /// This is to prevent bugs that may arise from conflicting stored data scheme.
    await secureStorage.delete(key: OfflineDataKey.aliases);
    await secureStorage.delete(key: OfflineDataKey.account);
    await secureStorage.delete(key: OfflineDataKey.username);
    await secureStorage.delete(key: OfflineDataKey.recipients);
    await secureStorage.delete(key: OfflineDataKey.domainOptions);
    await secureStorage.delete(key: OfflineDataKey.domain);
    await secureStorage.delete(key: OfflineDataKey.rules);
  }
}

/// Fetches current app version number.
Future<String?> _getCurrentAppVersion() async {
  try {
    final appVersion = await PackageInfo.fromPlatform();
    return appVersion.version;
  } catch (error) {
    return null;
  }
}

/// Fetches current app version number.
Future<String?> _getOldAppVersion(FlutterSecureStorage secureStorage) async {
  try {
    const key = ChangelogStorageKey.appVersionKey;
    final version = await secureStorage.read(key: key);
    return version;
  } catch (error) {
    return null;
  }
}
