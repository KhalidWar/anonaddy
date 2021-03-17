import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OfflineData {
  final _secureStorage = FlutterSecureStorage();

  String _aliasDataKey = 'aliasDataKey';
  String _accountDataKey = 'accountDataKey';
  String _usernameDataKey = 'usernameDataKey';

  Future<void> writeAliasOfflineData(String aliasData) async {
    await _secureStorage.write(key: _aliasDataKey, value: aliasData);
  }

  Future<String> readAliasOfflineData() async {
    return await _secureStorage.read(key: _aliasDataKey);
  }

  Future<void> writeAccountOfflineData(String aliasData) async {
    await _secureStorage.write(key: _accountDataKey, value: aliasData);
  }

  Future<String> readAccountOfflineData() async {
    return await _secureStorage.read(key: _accountDataKey);
  }

  Future<void> writeUsernameOfflineData(String aliasData) async {
    await _secureStorage.write(key: _usernameDataKey, value: aliasData);
  }

  Future<String> readUsernameOfflineData() async {
    return await _secureStorage.read(key: _usernameDataKey);
  }
}
