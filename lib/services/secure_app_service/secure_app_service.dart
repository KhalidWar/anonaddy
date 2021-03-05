import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureAppProvider =
    ChangeNotifierProvider<SecureAppService>((ref) => SecureAppService());

class SecureAppService extends ChangeNotifier {
  SecureAppService() {
    _isAppSecured = false;
    _loadSecureAppKey();
  }

  final _secureStorage = FlutterSecureStorage();
  final _secureAppKey = 'secureApp';

  bool _isAppSecured = false;
  bool get isAppSecured => _isAppSecured;

  toggleSecureApp() {
    _isAppSecured = !_isAppSecured;
    _saveSecureAppKey();
    notifyListeners();
  }

  Future<void> _saveSecureAppKey() async {
    await _secureStorage.write(
      key: _secureAppKey,
      value: _isAppSecured.toString(),
    );
  }

  Future<bool> _loadSecureAppKey() async {
    return _isAppSecured =
        await _secureStorage.read(key: _secureAppKey).then((value) {
      if (value == 'true') {
        return true;
      } else {
        return false;
      }
    });
  }
}
