import 'package:anonaddy/services/data_storage/settings_data_storage.dart';
import 'package:flutter/foundation.dart';

class SettingsStateManager extends ChangeNotifier {
  SettingsStateManager() {
    isAutoCopy = false;
    isAppSecured = false;
    loadAutoCopy();
    loadSecureApp();
  }

  final _settingsStorage = SettingsDataStorage();
  final _autoCopyKey = 'autoCopyKey';
  final _secureAppKey = 'secureApp';

  bool isAutoCopy;
  bool isAppSecured;

  void toggleAutoCopy() {
    isAutoCopy = !isAutoCopy;
    _settingsStorage.saveBoolState(_autoCopyKey, isAutoCopy);
    notifyListeners();
  }

  void loadAutoCopy() async {
    isAutoCopy = await _settingsStorage.loadBoolState(_autoCopyKey);
  }

  void toggleSecureApp() {
    isAppSecured = !isAppSecured;
    _settingsStorage.saveBoolState(_secureAppKey, isAppSecured);
    notifyListeners();
  }

  void loadSecureApp() async {
    isAppSecured = await _settingsStorage.loadBoolState(_secureAppKey);
  }
}
