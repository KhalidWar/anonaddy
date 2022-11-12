import 'dart:convert';

import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/data_storage/data_storage.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/data_storage_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final domainsDataStorageProvider = Provider<DomainsDataStorage>((ref) {
  return DomainsDataStorage(secureStorage: ref.read(flutterSecureStorage));
});

class DomainsDataStorage extends DataStorage {
  DomainsDataStorage({required this.secureStorage});
  final FlutterSecureStorage secureStorage;

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      final encodedData = jsonEncode(data);
      await secureStorage.write(
        key: DataStorageKeys.domainsKey,
        value: encodedData,
      );
    } catch (error) {
      return;
    }
  }

  @override
  Future<List<Domain>> loadData() async {
    try {
      final data = await secureStorage.read(key: DataStorageKeys.domainsKey);
      final decodedData = jsonDecode(data ?? '');
      final domains = (decodedData['data'] as List)
          .map((domain) => Domain.fromJson(domain))
          .toList();
      return domains;
    } catch (error) {
      rethrow;
    }
  }

  Future<Domain> loadSpecificDomain(String id) async {
    try {
      final domains = await loadData();
      final domain = domains.firstWhere((element) => element.id == id);
      return domain;
    } catch (error) {
      rethrow;
    }
  }
}
