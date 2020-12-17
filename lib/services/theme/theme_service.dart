import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeServiceProvider =
    ChangeNotifierProvider<ThemeService>((ref) => ThemeService());

class ThemeService extends ChangeNotifier {
  ThemeService() {
    _isDarkTheme = false;
    _loadTheme();
  }

  SharedPreferences _sharedPreferences;
  String _key = 'darkTheme';
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveTheme();
    notifyListeners();
  }

  _initSharedPref() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  _saveTheme() async {
    await _initSharedPref();
    _sharedPreferences.setBool(_key, _isDarkTheme);
  }

  _loadTheme() async {
    await _initSharedPref();
    _isDarkTheme = _sharedPreferences.getBool(_key) ?? false;
    notifyListeners();
  }
}
