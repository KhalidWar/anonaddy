import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OfflineData {
  OfflineData(this.secureStorage);
  final FlutterSecureStorage secureStorage;

  static const _aliasDataKey = 'aliasDataKey';
  static const _accountDataKey = 'accountDataKey';
  static const _usernameDataKey = 'usernameDataKey';
  static const _recipientsDataKey = 'recipientsDataKey';
  static const _domainOptionsDataKey = 'domainOptionsDataKey';
  static const _domainDataKey = 'domainDataKey';

  Future<void> writeAliasOfflineData(String data) async {
    await secureStorage.write(key: _aliasDataKey, value: data);
  }

  Future<String> readAliasOfflineData() async {
    final aliasData = await secureStorage.read(key: _aliasDataKey) ?? '';
    return aliasData;
  }

  Future<void> writeAccountOfflineData(String data) async {
    await secureStorage.write(key: _accountDataKey, value: data);
  }

  Future<String> readAccountOfflineData() async {
    final accountData = await secureStorage.read(key: _accountDataKey) ?? '';
    return accountData;
  }

  Future<void> writeUsernameOfflineData(String data) async {
    await secureStorage.write(key: _usernameDataKey, value: data);
  }

  Future<String> readUsernameOfflineData() async {
    final usernameData = await secureStorage.read(key: _usernameDataKey) ?? '';
    return usernameData;
  }

  Future<void> writeRecipientsOfflineData(String data) async {
    await secureStorage.write(key: _recipientsDataKey, value: data);
  }

  Future<String> readRecipientsOfflineData() async {
    final recipientData =
        await secureStorage.read(key: _recipientsDataKey) ?? '';
    return recipientData;
  }

  Future<void> writeDomainOptionsOfflineData(String data) async {
    await secureStorage.write(key: _domainOptionsDataKey, value: data);
  }

  Future<String> readDomainOptionsOfflineData() async {
    final domainOptionsData =
        await secureStorage.read(key: _domainOptionsDataKey) ?? '';
    return domainOptionsData;
  }

  Future<void> writeDomainOfflineData(String data) async {
    await secureStorage.write(key: _domainDataKey, value: data);
  }

  Future<String> readDomainOfflineData() async {
    final domainData = await secureStorage.read(key: _domainDataKey) ?? '';
    return domainData;
  }
}
