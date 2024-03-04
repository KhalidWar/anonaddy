import 'dart:async';
import 'dart:convert';

import 'package:anonaddy/features/settings/data/offline_data_storage.dart';
import 'package:anonaddy/features/settings/presentation/controller/settings_state.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final settingsNotifier = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
    SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  Future<void> toggleTheme() async {
    try {
      final currentState = state.value!;
      state = AsyncValue.data(
        currentState.copyWith(
          isDarkTheme: !currentState.isDarkTheme,
        ),
      );
      await _saveNewSettingsState();
    } catch (error) {
      Utilities.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<void> toggleAutoCopy() async {
    try {
      final currentState = state.value!;
      state = AsyncValue.data(
        currentState.copyWith(
          isAutoCopyEnabled: !currentState.isAutoCopyEnabled,
        ),
      );
      await _saveNewSettingsState();
    } catch (error) {
      Utilities.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<void> toggleBiometric() async {
    try {
      final currentState = state.value!;
      state = AsyncValue.data(currentState.copyWith(
        isBiometricEnabled: !currentState.isBiometricEnabled,
      ));
      await _saveNewSettingsState();
    } catch (error) {
      Utilities.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<void> showChangelogIfAppUpdated() async {
    try {
      final packageInfo = await _getPackageInfo();
      if (packageInfo != null) {
        final currentAppVersion = packageInfo.version;
        final oldAppVersion = state.value?.appVersion;
        final isUpdated = oldAppVersion != currentAppVersion;

        if (isUpdated) {
          final currentState = state.value;
          if (currentState == null) return;
          state = AsyncValue.data(currentState.copyWith(showChangelog: true));
        }
      }
    } catch (error) {
      return;
    }
  }

  Future<void> dismissChangelog() async {
    try {
      final packageInfo = await _getPackageInfo();
      if (packageInfo != null) {
        final currentAppVersion = packageInfo.version;
        final newState = state.value?.copyWith(
          appVersion: currentAppVersion,
          showChangelog: false,
        );
        if (newState != null) {
          state = AsyncValue.data(newState);
        }

        await ref
            .read(offlineDataProvider)
            .saveCurrentAppVersion(currentAppVersion);
        await _saveNewSettingsState();
      }
    } catch (error) {
      return;
    }
  }

  Future<void> _saveNewSettingsState() async {
    try {
      final mappedState = state.value!.toMap();
      final encodedState = json.encode(mappedState);
      await ref.read(offlineDataProvider).saveSettingsState(encodedState);
    } catch (error) {
      return;
    }
  }

  Future<PackageInfo?> _getPackageInfo() async {
    try {
      return await PackageInfo.fromPlatform();
    } catch (e) {
      return null;
    }
  }

  @override
  FutureOr<SettingsState> build() async {
    final storage = ref.read(offlineDataProvider);

    final encodedState = await storage.loadSettingsState();
    if (encodedState == null) {
      return SettingsState(
        isAutoCopyEnabled: true,
        isDarkTheme: false,
        isBiometricEnabled: false,
        showChangelog: false,
        appVersion: '',
      );
    }

    final settingsState = SettingsState.fromMap(json.decode(encodedState));
    return SettingsState(
      isAutoCopyEnabled: settingsState.isAutoCopyEnabled,
      isDarkTheme: settingsState.isDarkTheme,
      isBiometricEnabled: settingsState.isBiometricEnabled,
      showChangelog: settingsState.showChangelog,
      appVersion: settingsState.appVersion,
    );
  }
}
