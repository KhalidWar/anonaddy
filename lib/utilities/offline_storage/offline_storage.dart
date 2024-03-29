import 'dart:convert';

import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:anonaddy/shared_components/constants/data_storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class OfflineStorage<T> {
  const OfflineStorage({
    required this.secureStorage,
  });

  final FlutterSecureStorage secureStorage;

  Future<bool> saveData(T data) async {
    try {
      final encodedData = jsonEncode(data);
      final storageKey = _getStorageKey<T>();
      if (storageKey == null) return false;

      await secureStorage.write(
        key: storageKey,
        value: encodedData,
      );
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> loadData() async {
    try {
      final storageKey = _getStorageKey<T>();
      if (storageKey == null) return null;

      final data = await secureStorage.read(key: storageKey);
      if (data == null) return null;

      final decodedData = jsonDecode(data);
      return decodedData;
    } catch (error) {
      return null;
    }
  }

  String? _getStorageKey<K>() {
    if (K is Username) {
      return DataStorageKeys.usernameKey;
    }

    return null;
  }
}
