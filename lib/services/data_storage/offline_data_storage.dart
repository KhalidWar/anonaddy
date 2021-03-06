import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OfflineData {
  final _secureStorage = FlutterSecureStorage();

  final _aliasDataKey = 'aliasDataKey';
  String _aliasData = '';

  final _accountDataKey = 'accountDataKey';
  String _accountData = '';

  final _usernameDataKey = 'usernameDataKey';
  String _usernameData = '';

  final _recipientsDataKey = 'recipientsDataKey';
  String _recipientData = '';

  final _domainOptionsDataKey = 'domainOptionsDataKey';
  String _domainOptionsData = '';

  final _domainDataKey = 'domainDataKey';
  String _domainData = '';

  Future<void> writeAliasOfflineData(String data) async {
    if (_aliasData.compareTo(data) != 0) {
      _aliasData = data;
      await _secureStorage.write(key: _aliasDataKey, value: data);
    }
  }

  Future<String> readAliasOfflineData() async {
    if (_aliasData.isEmpty) {
      _aliasData = await _secureStorage.read(key: _aliasDataKey) ?? '';
      return _aliasData;
    } else {
      return _aliasData;
    }
  }

  Future<void> writeAccountOfflineData(String data) async {
    if (_accountData.compareTo(data) != 0) {
      _accountData = data;
      await _secureStorage.write(key: _accountDataKey, value: data);
    }
  }

  Future<String> readAccountOfflineData() async {
    if (_accountData.isEmpty) {
      _accountData = await _secureStorage.read(key: _accountDataKey) ?? '';
      return _accountData;
    } else {
      return _accountData;
    }
  }

  Future<void> writeUsernameOfflineData(String data) async {
    if (_usernameData.compareTo(data) != 0) {
      _usernameData = data;
      await _secureStorage.write(key: _usernameDataKey, value: data);
    }
  }

  Future<String> readUsernameOfflineData() async {
    if (_usernameData.isEmpty) {
      _usernameData = await _secureStorage.read(key: _usernameDataKey);
      return _usernameData;
    } else {
      return _usernameData;
    }
  }

  Future<void> writeRecipientsOfflineData(String data) async {
    if (_recipientData.compareTo(data) != 0) {
      _recipientData = data;
      await _secureStorage.write(key: _recipientsDataKey, value: data);
    }
  }

  Future<String> readRecipientsOfflineData() async {
    if (_recipientData.isEmpty) {
      _recipientData = await _secureStorage.read(key: _recipientsDataKey) ?? '';
      return _recipientData;
    } else {
      return _recipientData;
    }
  }

  Future<void> writeDomainOptionsOfflineData(String data) async {
    if (_domainOptionsData.compareTo(data) != 0) {
      _domainOptionsData = data;
      await _secureStorage.write(key: _domainOptionsDataKey, value: data);
    }
  }

  Future<String> readDomainOptionsOfflineData() async {
    if (_domainOptionsData.isEmpty) {
      _domainOptionsData =
          await _secureStorage.read(key: _domainOptionsDataKey);
      return _domainOptionsData;
    } else {
      return _domainOptionsData;
    }
  }

  Future<void> writeDomainOfflineData(String data) async {
    if (_domainData.compareTo(data) != 0) {
      _domainData = data;
      await _secureStorage.write(key: _domainDataKey, value: data);
    }
  }

  Future<String> readDomainOfflineData() async {
    if (_domainData.isEmpty) {
      _domainData = await _secureStorage.read(key: _domainDataKey);
      return _domainData;
    } else {
      return _domainData;
    }
  }
}
