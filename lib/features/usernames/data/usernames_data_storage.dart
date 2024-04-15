import 'dart:convert';

import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/data_storage.dart';
import 'package:anonaddy/common/flutter_secure_storage.dart';
import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final usernameDataStorageProvider = Provider<UsernamesDataStorage>((ref) {
  return UsernamesDataStorage(secureStorage: ref.read(flutterSecureStorage));
});

class UsernamesDataStorage extends DataStorage {
  UsernamesDataStorage({required this.secureStorage});
  final FlutterSecureStorage secureStorage;

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      final encodedData = jsonEncode(data);
      await secureStorage.write(
        key: DataStorageKeys.usernameKey,
        value: encodedData,
      );
    } catch (error) {
      return;
    }
  }

  @override
  Future<List<Username>?> loadData() async {
    try {
      final data = await secureStorage.read(key: DataStorageKeys.usernameKey);
      if (data == null) return null;
      final decodedData = jsonDecode(data);
      final usernames = (decodedData['data'] as List)
          .map((username) => Username.fromJson(username))
          .toList();
      return usernames;
    } catch (error) {
      rethrow;
    }
  }

  Future<Username> loadSpecificUsername(String id) async {
    try {
      final usernames = await loadData();
      final username = usernames!.firstWhere((element) => element.id == id);
      return username;
    } catch (error) {
      rethrow;
    }
  }
}
