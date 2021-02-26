import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final themeServiceProvider =
    ChangeNotifierProvider<ThemeService>((ref) => ThemeService());

class ThemeService extends ChangeNotifier {
  ThemeService() {
    _isDarkTheme = false;
    _loadTheme();
  }

  final _secureStorage = FlutterSecureStorage();
  String _darkThemeKey = 'darkTheme';

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveTheme();
    notifyListeners();
  }

  _saveTheme() {
    _secureStorage.write(key: _darkThemeKey, value: _isDarkTheme.toString());
  }

  _loadTheme() async {
    _isDarkTheme = await _secureStorage.read(key: _darkThemeKey).then((value) {
      if (value == 'true') {
        return true;
      }
      return false;
    });
    notifyListeners();
  }
}
