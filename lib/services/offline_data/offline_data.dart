import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OfflineData {
  final _secureStorage = FlutterSecureStorage();

  String _aliasDataKey = 'aliasDataKey';
  String _accountDataKey = 'accountDataKey';
  String _usernameDataKey = 'usernameDataKey';
  String _recipientsDataKey = 'recipientsDataKey';
  String _domainOptionsDataKey = 'domainOptionsDataKey';

  Future<void> writeAliasOfflineData(String data) async {
    await _secureStorage.write(key: _aliasDataKey, value: data);
  }

  Future<String> readAliasOfflineData() async {
    return await _secureStorage.read(key: _aliasDataKey);
  }

  Future<void> writeAccountOfflineData(String data) async {
    await _secureStorage.write(key: _accountDataKey, value: data);
  }

  Future<String> readAccountOfflineData() async {
    return await _secureStorage.read(key: _accountDataKey);
  }

  Future<void> writeUsernameOfflineData(String data) async {
    await _secureStorage.write(key: _usernameDataKey, value: data);
  }

  Future<String> readUsernameOfflineData() async {
    return await _secureStorage.read(key: _usernameDataKey);
  }

  Future<void> writeRecipientsOfflineData(String data) async {
    await _secureStorage.write(key: _recipientsDataKey, value: data);
  }

  Future<String> readRecipientsOfflineData() async {
    return await _secureStorage.read(key: _recipientsDataKey);
  }

  Future<void> writeDomainOptionsOfflineData(String data) async {
    await _secureStorage.write(key: _domainOptionsDataKey, value: data);
  }

  Future<String> readDomainOptionsOfflineData() async {
    return await _secureStorage.read(key: _domainOptionsDataKey);
  }
}
