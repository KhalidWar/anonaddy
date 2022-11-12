import 'dart:convert';

import 'package:anonaddy/models/rules/rules.dart';
import 'package:anonaddy/services/data_storage/data_storage.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/data_storage_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final rulesDataStorageProvider = Provider<RulesDataStorage>((ref) {
  return RulesDataStorage(secureStorage: ref.read(flutterSecureStorage));
});

class RulesDataStorage extends DataStorage {
  RulesDataStorage({required this.secureStorage});
  final FlutterSecureStorage secureStorage;

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      final encodedData = jsonEncode(data);
      await secureStorage.write(
        key: DataStorageKeys.rulesKey,
        value: encodedData,
      );
    } catch (error) {
      return;
    }
  }

  @override
  Future<List<Rules>> loadData() async {
    try {
      final data = await secureStorage.read(key: DataStorageKeys.rulesKey);
      final decodedData = jsonDecode(data ?? '');
      final rules = (decodedData['data'] as List)
          .map((rule) => Rules.fromJson(rule))
          .toList();
      return rules;
    } catch (error) {
      rethrow;
    }
  }

  Future<Rules> loadSpecificRule(String id) async {
    try {
      final rules = await loadData();
      final rule = rules.firstWhere((element) => element.id == id);
      return rule;
    } catch (error) {
      rethrow;
    }
  }
}
