import 'dart:convert';

import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/state_management/settings/settings_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsStateNotifier =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(
    offlineData: ref.read(offlineDataProvider),
  );
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier({
    required this.offlineData,
    SettingsState? initialState,
  }) : super(initialState ?? SettingsState.initial());

  final OfflineData offlineData;

  void _updateState(SettingsState newState) {
    if (mounted) {
      state = newState;
      _saveSettingsState();
    }
  }

  void toggleTheme() {
    try {
      _updateState(state.copyWith(isDarkTheme: !state.isDarkTheme));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  void toggleAutoCopy() {
    try {
      _updateState(state.copyWith(isAutoCopyEnabled: !state.isAutoCopyEnabled));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  void toggleBiometric() {
    try {
      _updateState(
        state.copyWith(isBiometricEnabled: !state.isBiometricEnabled),
      );
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<void> _saveSettingsState() async {
    try {
      final mappedState = state.toMap();
      final encodedState = json.encode(mappedState);
      await offlineData.saveSettingsState(encodedState);
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<void> loadSettingsState() async {
    try {
      final securedData = await offlineData.loadSettingsState();
      if (securedData.isNotEmpty) {
        final mappedState = json.decode(securedData);
        final storedState = SettingsState.fromMap(mappedState);
        _updateState(storedState);
      }
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }
}
