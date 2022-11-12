import 'dart:convert';

import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/data_storage/data_storage.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/data_storage_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final domainOptionsDataStorageProvider =
    Provider<DomainOptionsDataStorage>((ref) {
  return DomainOptionsDataStorage(
    secureStorage: ref.read(flutterSecureStorage),
  );
});

class DomainOptionsDataStorage extends DataStorage {
  const DomainOptionsDataStorage({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      final encodedData = jsonEncode(data);
      await secureStorage.write(
        key: DataStorageKeys.domainOptionsKey,
        value: encodedData,
      );
    } catch (_) {
      return;
    }
  }

  @override
  Future<DomainOptions> loadData() async {
    try {
      final data =
          await secureStorage.read(key: DataStorageKeys.domainOptionsKey);
      final decodedData = jsonDecode(data ?? '');
      final domainOptions = DomainOptions.fromJson(decodedData);
      return domainOptions;
    } catch (error) {
      rethrow;
    }
  }
}
