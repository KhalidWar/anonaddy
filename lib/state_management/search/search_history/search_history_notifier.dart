import 'dart:convert';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/secure_storage/secure_storage.dart';
import 'package:anonaddy/state_management/search/search_history/search_history_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

final searchHistoryStateNotifier =
    StateNotifierProvider<SearchHistoryNotifier, SearchHistoryState>((ref) {
  final secureStorage = ref.read(flutterSecureStorageProvider);
  return SearchHistoryNotifier(secureStorage: secureStorage);
});

class SearchHistoryNotifier extends StateNotifier<SearchHistoryState> {
  SearchHistoryNotifier({required this.secureStorage})
      : super(SearchHistoryState.initialState());

  final FlutterSecureStorage secureStorage;

  static const _kHiveSecureKey = 'hiveSecureKey';
  static const _kSearchHistoryBox = 'searchHistoryBoxKey';

  /// Updates UI to latest state
  void _updateState(SearchHistoryState newState) {
    if (mounted) state = newState;
  }

  Future<void> addAliasToSearchHistory(Alias alias) async {
    try {
      final box = Hive.box<Alias>(_kSearchHistoryBox);
      box.add(alias);
      final newState =
          state.copyWith(aliases: box.values.toList().cast<Alias>());
      _updateState(newState);
    } catch (error) {
      final newState = state.copyWith(
        status: SearchHistoryStatus.failed,
        errorMessage: error.toString(),
      );
      _updateState(newState);
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      final box = Hive.box<Alias>(_kSearchHistoryBox);
      await box.clear();

      final newState = state.copyWith(
        status: SearchHistoryStatus.loaded,
        aliases: [],
      );
      _updateState(newState);
    } catch (error) {
      final newState = state.copyWith(
        status: SearchHistoryStatus.failed,
        errorMessage: error.toString(),
      );
      _updateState(newState);
    }
  }

  Future<void> initSearchHistory() async {
    try {
      final encryptionKey = await _getEncryptionKey();

      final box = await Hive.openBox<Alias>(
        _kSearchHistoryBox,
        encryptionCipher: HiveAesCipher(encryptionKey),
      );

      final newState = state.copyWith(
        status: SearchHistoryStatus.loaded,
        aliases: box.isEmpty ? [] : box.values.toList().cast<Alias>(),
      );
      _updateState(newState);
    } catch (error) {
      final newState = state.copyWith(
        status: SearchHistoryStatus.failed,
        errorMessage: error.toString(),
      );
      _updateState(newState);
    }
  }

  Future<List<int>> _getEncryptionKey() async {
    try {
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
}
