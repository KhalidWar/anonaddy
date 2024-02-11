import 'dart:convert';

import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/shared_components/constants/data_storage_keys.dart';
import 'package:anonaddy/utilities/data_storage.dart';
import 'package:anonaddy/utilities/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final accountDataStorageProvider = Provider<AccountDataStorage>((ref) {
  return AccountDataStorage(secureStorage: ref.read(flutterSecureStorage));
});

class AccountDataStorage extends DataStorage {
  const AccountDataStorage({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      final encodedData = jsonEncode(data);
      await secureStorage.write(
        value: encodedData,
        key: DataStorageKeys.accountKey,
      );
    } catch (_) {
      return;
    }
  }

  @override
  Future<Account?> loadData() async {
    try {
      final data = await secureStorage.read(key: DataStorageKeys.accountKey);
      if (data == null) return null;

      final decodedAccount = jsonDecode(data);
      final account = Account.fromJson(decodedAccount);
      return account;
    } catch (_) {
      rethrow;
    }
  }
}
