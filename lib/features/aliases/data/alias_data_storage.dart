import 'dart:convert';

import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/flutter_secure_storage.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final aliasDataStorageProvider = Provider<AliasDataStorage>((ref) {
  return AliasDataStorage(secureStorage: ref.read(flutterSecureStorage));
});

/// It's responsible for saving and loading [Alias] data to and from device storage.
class AliasDataStorage {
  const AliasDataStorage({required this.secureStorage});
  final FlutterSecureStorage secureStorage;

  Future<void> saveAliases({required List aliases}) async {
    try {
      final encodedAliases = jsonEncode(aliases);
      await secureStorage.write(
        key: DataStorageKeys.aliasesKey,
        value: encodedAliases,
      );
    } catch (_) {
      return;
    }
  }

  Future<List<Alias>?> loadAliases() async {
    try {
      final data = await secureStorage.read(key: DataStorageKeys.aliasesKey);

      if (data == null) return null;

      final decodedAliases = jsonDecode(data);
      final aliases = (decodedAliases as List)
          .map((alias) => Alias.fromJson(alias))
          .toList();
      return aliases;
    } catch (_) {
      return null;
    }
  }
}
