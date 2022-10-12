import 'dart:convert';

import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/data_storage_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final accountDataStorageProvider = Provider<AccountDataStorage>((ref) {
  return AccountDataStorage(secureStorage: ref.read(flutterSecureStorage));
});

class AccountDataStorage {
  const AccountDataStorage({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  Future<void> saveAccount(Map<String, dynamic> accountData) async {
    try {
      final encodedData = jsonEncode(accountData);
      await secureStorage.write(
        value: encodedData,
        key: DataStorageKeys.accountTabKey,
      );
    } catch (_) {
      return;
    }
  }

  Future<Account> loadAccount() async {
    try {
      final data = await secureStorage.read(key: DataStorageKeys.accountTabKey);
      final decodedAccount = jsonDecode(data ?? '');
      final account = Account.fromJson(decodedAccount);
      return account;
    } catch (_) {
      rethrow;
    }
  }
}
