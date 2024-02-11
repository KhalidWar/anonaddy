import 'dart:async';
import 'dart:convert';

import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/utilities/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

final searchHistoryStateNotifier =
    AsyncNotifierProvider<SearchHistoryNotifier, List<Alias>>(
        SearchHistoryNotifier.new);

class SearchHistoryNotifier extends AsyncNotifier<List<Alias>> {
  static const _kHiveSecureKey = 'hiveSecureKey';
  static const _kSearchHistoryBox = 'searchHistoryBoxKey';

  Future<void> addAliasToSearchHistory(Alias alias) async {
    try {
      final box = Hive.box<Alias>(_kSearchHistoryBox);
      box.add(alias);

      state = AsyncData(box.values.toList().cast<Alias>());
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.empty);
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      final box = Hive.box<Alias>(_kSearchHistoryBox);
      await box.clear();

      state = const AsyncData(<Alias>[]);
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.empty);
    }
  }

  Future<List<int>> _getEncryptionKey() async {
    try {
      final FlutterSecureStorage secureStorage =
          ref.read(flutterSecureStorageProvider);

      /// Encryption key is [List<int>] according to the documentation.
      late List<int> encryptionKey;

      /// Fetch saved encryptionKey from device storage
      final savedEncryptionKey = await secureStorage.read(key: _kHiveSecureKey);

      /// If encryptionKey doesn't exist, generate a new key and save it.
      if (savedEncryptionKey == null) {
        final newKey = Hive.generateSecureKey();
        await secureStorage.write(
          key: _kHiveSecureKey,
          value: base64UrlEncode(newKey),
        );
      }

      /// Load encryptionKey from device storage and decode it
      final savedKey = await secureStorage.read(key: _kHiveSecureKey);
      if (savedKey == null) throw 'Failed to load encryption keys';
      encryptionKey = base64Url.decode(savedKey);

      return encryptionKey;
    } catch (error) {
      rethrow;
    }
  }

  @override
  FutureOr<List<Alias>> build() async {
    final encryptionKey = await _getEncryptionKey();

    final box = await Hive.openBox<Alias>(
      _kSearchHistoryBox,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    return box.isEmpty ? [] : box.values.toList().cast<Alias>();
  }
}
