import 'package:anonaddy/services/data_storage/settings_data_storage.dart';
import 'package:flutter/foundation.dart';

class SettingsStateManager extends ChangeNotifier {
  SettingsStateManager() {
    isAutoCopy = false;
    isAppSecured = false;
    isDarkTheme = false;
    _loadSavedData();
  }

  final _settingsStorage = SettingsDataStorage();
  final _autoCopyKey = 'autoCopyKey';
  final _secureAppKey = 'secureApp';
  final _darkThemeKey = 'darkTheme';

  bool isAutoCopy;
  bool isAppSecured;
  bool isDarkTheme;

  void _loadSavedData() async {
    isDarkTheme = await _settingsStorage.loadBoolState(_darkThemeKey);
    isAppSecured = await _settingsStorage.loadBoolState(_secureAppKey);
    isAutoCopy = await _settingsStorage.loadBoolState(_autoCopyKey);
    notifyListeners();
  }

  void toggleAutoCopy() {
    isAutoCopy = !isAutoCopy;
    _settingsStorage.saveBoolState(_autoCopyKey, isAutoCopy);
    notifyListeners();
  }

  void toggleSecureApp() {
    isAppSecured = !isAppSecured;
    _settingsStorage.saveBoolState(_secureAppKey, isAppSecured);
    notifyListeners();
  }

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    _settingsStorage.saveBoolState(_darkThemeKey, isDarkTheme);
    notifyListeners();
  }
}
