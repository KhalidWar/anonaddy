import 'dart:convert';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/state_management/search/search_history_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

final searchHistoryStateNotifier =
    StateNotifierProvider<SearchHistoryNotifier, SearchHistoryState>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  return SearchHistoryNotifier(secureStorage: secureStorage);
});

class SearchHistoryNotifier extends StateNotifier<SearchHistoryState> {
  SearchHistoryNotifier({required this.secureStorage})
      : super(SearchHistoryState(
          status: SearchHistoryStatus.loading,
          aliases: [],
        )) {
    _initState();
  }

  final FlutterSecureStorage secureStorage;

  static const _kHiveSecureKey = 'hiveSecureKey';
  static const _kSearchHistoryBox = 'searchHistoryBoxKey';

  Future<void> addAliasToSearchHistory(Alias alias) async {
    try {
      final box = Hive.box<Alias>(_kSearchHistoryBox);
      box.add(alias);
      state = state.copyWith(aliases: box.values.toList().cast<Alias>());
    } catch (error) {
      state.copyWith(
        status: SearchHistoryStatus.failed,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      final box = Hive.box<Alias>(_kSearchHistoryBox);
      await box.clear();
      state = state.copyWith(
        status: SearchHistoryStatus.loaded,
        aliases: [],
      );
    } catch (error) {
      state.copyWith(
        status: SearchHistoryStatus.failed,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> _initState() async {
    try {
      await _generateKeys();

      final data = await secureStorage.read(key: _kHiveSecureKey);
      final encryptionKey = base64Url.decode(data!);
      final box = await Hive.openBox<Alias>(
        _kSearchHistoryBox,
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
      state = state.copyWith(
        status: SearchHistoryStatus.loaded,
        aliases: box.isEmpty ? [] : box.values.toList().cast<Alias>(),
      );
    } catch (error) {
      state.copyWith(
        status: SearchHistoryStatus.failed,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> _generateKeys() async {
    try {
      final containsEncryptionKey =
          await secureStorage.containsKey(key: _kHiveSecureKey);
      if (!containsEncryptionKey) {
        final key = Hive.generateSecureKey();
        await secureStorage.write(
            key: _kHiveSecureKey, value: base64UrlEncode(key));
      }
    } catch (error) {
      state.copyWith(
        status: SearchHistoryStatus.failed,
        errorMessage: error.toString(),
      );
    }
  }
}
