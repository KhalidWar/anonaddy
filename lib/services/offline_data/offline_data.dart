import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OfflineData {
  final _secureStorage = FlutterSecureStorage();

  String _aliasDataKey = 'aliasDataKey';

  Future<void> writeAliasOfflineData(String aliasData) async {
    await _secureStorage.write(key: _aliasDataKey, value: aliasData);
  }

  Future<String> readAliasOfflineData() async {
    return await _secureStorage.read(key: _aliasDataKey);
  }
}
