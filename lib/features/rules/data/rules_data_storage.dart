import 'dart:convert';

import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/data_storage.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/rules/domain/rule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final rulesDataStorageProvider = Provider<RulesDataStorage>((ref) {
  return RulesDataStorage(
      secureStorage: ref.read(flutterSecureStorageProvider));
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
  Future<List<Rule>?> loadData() async {
    try {
      final data = await secureStorage.read(key: DataStorageKeys.rulesKey);
      if (data == null) return null;
      final decodedData = jsonDecode(data);
      final rules = (decodedData['data'] as List)
          .map((rule) => Rule.fromJson(rule))
          .toList();
      return rules;
    } catch (error) {
      rethrow;
    }
  }

  Future<Rule?> loadSpecificRule(String id) async {
    try {
      final rules = await loadData();
      if (rules == null) return null;

      return rules.firstWhere((element) => element.id == id);
    } catch (error) {
      return null;
    }
  }
}
