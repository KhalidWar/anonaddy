import 'dart:async';
import 'dart:io';

import 'package:anonaddy/common/constants/changelog_storage_key.dart';
import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/features/settings/presentation/controller/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

const revenueCatAndroidAPIKey =
    String.fromEnvironment('revenue-cat-android-api-key');
const revenueCatIOSAPIKey = String.fromEnvironment('revenue-cat-ios-api-key');

final appStartupProvider =
    AsyncNotifierProvider<AppStartupNotifier, void>(AppStartupNotifier.new);

class AppStartupNotifier extends AsyncNotifier<void> {
  Future<void> _configureRevenueCat({
    required String androidApiKey,
    required String iOSApiKey,
  }) async {
    try {
      await Purchases.setLogLevel(LogLevel.debug);

      PurchasesConfiguration? configuration;

      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(androidApiKey);
      }

      if (Platform.isIOS) {
        configuration = PurchasesConfiguration(iOSApiKey);
      }

      if (configuration != null) {
        await Purchases.configure(configuration);
      }
    } catch (_) {
      return;
    }
  }

  /// Does housekeeping after app is updated. Does nothing otherwise.
  Future<void> _handleAppUpdate(FlutterSecureStorage secureStorage) async {
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

  Future<String?> _getCurrentAppVersion() async {
    try {
      final appVersion = await PackageInfo.fromPlatform();
      return appVersion.version;
    } catch (error) {
      return null;
    }
  }

  Future<void> _saveCurrentAppVersion(
    FlutterSecureStorage secureStorage,
    String currentAppVersion,
  ) async {
    try {
      await secureStorage.write(
        key: ChangelogStorageKey.appVersionKey,
        value: currentAppVersion,
      );
    } catch (error) {
      return;
    }
  }

  Future<String?> _getOldAppVersion(FlutterSecureStorage secureStorage) async {
    try {
      const key = ChangelogStorageKey.appVersionKey;
      final version = await secureStorage.read(key: key);
      return version;
    } catch (error) {
      return null;
    }
  }

  Future<void> _deleteChangelog(FlutterSecureStorage secureStorage) async {
    try {
      await secureStorage.delete(key: ChangelogStorageKey.changelogKey);
    } catch (error) {
      return;
    }
  }

  Future<void> _deleteOfflineData(FlutterSecureStorage secureStorage) async {
    try {
      await secureStorage.delete(key: DataStorageKeys.aliasesKey);
      await secureStorage.delete(key: DataStorageKeys.accountKey);
      await secureStorage.delete(key: DataStorageKeys.recipientKey);
      await secureStorage.delete(key: DataStorageKeys.usernameKey);
      await secureStorage.delete(key: DataStorageKeys.domainsKey);
      await secureStorage.delete(key: DataStorageKeys.rulesKey);
      await secureStorage.delete(key: DataStorageKeys.domainOptionsKey);
      await secureStorage.delete(key: DataStorageKeys.searchHistoryKey);
    } catch (error) {
      return;
    }
  }

  Future<void> logout() async {
    try {
      await ref.read(flutterSecureStorageProvider).deleteAll();
      ref.invalidateSelf();
    } catch (error) {
      return;
    }
  }

  Future<void> refresh() async {
    try {
      state = const AsyncError('Refreshing...', StackTrace.empty);
    } catch (error) {
      return;
    }
  }

  @override
  FutureOr<void> build() async {
    ref.onDispose(() async {
      ref.invalidate(flutterSecureStorageProvider);
      ref.invalidate(settingsNotifierProvider);
      ref.invalidate(authNotifierProvider);
    });

    final secureStorage = ref.read(flutterSecureStorageProvider);

    await _handleAppUpdate(secureStorage);
    await _configureRevenueCat(
      androidApiKey: revenueCatAndroidAPIKey,
      iOSApiKey: revenueCatIOSAPIKey,
    );

    await ref.read(settingsNotifierProvider.future);
    await ref.read(authNotifierProvider.future);
  }
}
