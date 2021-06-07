import 'package:anonaddy/services/data_storage/settings_data_storage.dart';
import 'package:flutter/foundation.dart';

class SettingsStateManager extends ChangeNotifier {
  SettingsStateManager() {
    isDarkTheme = false;
    isBiometricAuth = false;
    isAutoCopy = false;
    _loadSavedData();
  }

  final _settingsStorage = SettingsDataStorage();
  final _autoCopyKey = 'autoCopyKey';
  final _biometricAuthKey = 'biometricAuthKey';
  final _darkThemeKey = 'darkTheme';

  bool isAutoCopy;
  bool isBiometricAuth;
  bool isDarkTheme;

  void _loadSavedData() async {
    isDarkTheme = await _settingsStorage.loadBoolState(_darkThemeKey) ?? false;
    isBiometricAuth =
        await _settingsStorage.loadBoolState(_biometricAuthKey) ?? false;
    isAutoCopy = await _settingsStorage.loadBoolState(_autoCopyKey) ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    _settingsStorage.saveBoolState(_darkThemeKey, isDarkTheme);
    notifyListeners();
  }

  void toggleBiometricRequired() {
    isBiometricAuth = !isBiometricAuth;
    _settingsStorage.saveBoolState(_biometricAuthKey, isBiometricAuth);
    notifyListeners();
  }

  void toggleAutoCopy() {
    isAutoCopy = !isAutoCopy;
    _settingsStorage.saveBoolState(_autoCopyKey, isAutoCopy);
    notifyListeners();
  }
}
