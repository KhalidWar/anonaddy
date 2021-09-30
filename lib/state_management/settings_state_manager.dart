import 'package:anonaddy/services/data_storage/settings_data_storage.dart';
import 'package:flutter/foundation.dart';

class SettingsStateManager extends ChangeNotifier {
  SettingsStateManager({required this.settingsStorage}) {
    isDarkTheme = false;
    isAutoCopy = false;
    _loadSavedData();
  }
  final SettingsDataStorage settingsStorage;

  final _autoCopyKey = 'autoCopyKey';
  final _darkThemeKey = 'darkTheme';

  late bool isAutoCopy;
  late bool isDarkTheme;

  void _loadSavedData() async {
    isDarkTheme = await settingsStorage.loadBoolState(_darkThemeKey) ?? false;
    isAutoCopy = await settingsStorage.loadBoolState(_autoCopyKey) ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    settingsStorage.saveBoolState(_darkThemeKey, isDarkTheme);
    notifyListeners();
  }

  void toggleAutoCopy() {
    isAutoCopy = !isAutoCopy;
    settingsStorage.saveBoolState(_autoCopyKey, isAutoCopy);
    notifyListeners();
  }
}
