import 'dart:convert';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/data_storage_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final aliasDataStorageProvider = Provider<AliasDataStorage>((ref) {
  return AliasDataStorage(secureStorage: ref.read(flutterSecureStorage));
});

/// It's responsible for saving and loading [Alias] data to and from device storage.
class AliasDataStorage {
  const AliasDataStorage({required this.secureStorage});
  final FlutterSecureStorage secureStorage;

  Future<void> saveAliases({
    required List aliases,
    required bool isAvailableAliases,
  }) async {
    try {
      final encodedAliases = jsonEncode(aliases);
      await secureStorage.write(
        key: isAvailableAliases
            ? DataStorageKeys.availableAliasesKey
            : DataStorageKeys.deletedAliasesKey,
        value: encodedAliases,
      );
    } catch (_) {
      return;
    }
  }

  Future<List<Alias>?> loadAliases({required bool isAvailableAliases}) async {
    try {
      final data = await secureStorage.read(
        key: isAvailableAliases
            ? DataStorageKeys.availableAliasesKey
            : DataStorageKeys.deletedAliasesKey,
      );

      if (data == null) return null;

      final decodedAliases = jsonDecode(data);
      final aliases = (decodedAliases as List)
          .map((alias) => Alias.fromJson(alias))
          .toList();
      return aliases;
    } catch (_) {
      return [];
    }
  }

  Future<Alias?> loadSpecificAlias(String id) async {
    try {
      final availableAliases = await loadAliases(isAvailableAliases: true);
      final deletedAliases = await loadAliases(isAvailableAliases: false);

      final List<Alias?> aliases = [...?availableAliases, ...?deletedAliases];
      final alias = aliases.firstWhere((element) => element?.id == id);
      return alias;
    } catch (error) {
      rethrow;
    }
  }
}
