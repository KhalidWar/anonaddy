import 'dart:async';
import 'dart:convert';

import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchHistoryNotifierProvider =
    AsyncNotifierProvider<SearchHistoryNotifier, List<Alias>>(
        SearchHistoryNotifier.new);

class SearchHistoryNotifier extends AsyncNotifier<List<Alias>> {
  Future<void> addAliasToSearchHistory(Alias alias) async {
    try {
      final aliases = state.value;
      if (aliases == null) return;
      if (aliases.contains(alias)) return;

      final updatedAliases = [...aliases, alias];

      await ref.read(flutterSecureStorageProvider).write(
            key: DataStorageKeys.searchHistoryKey,
            value: jsonEncode(updatedAliases),
          );

      state = AsyncData(updatedAliases);
    } catch (error) {
      return;
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      await ref
          .read(flutterSecureStorageProvider)
          .delete(key: DataStorageKeys.searchHistoryKey);

      state = const AsyncData(<Alias>[]);
    } catch (error) {
      Utilities.showToast('Failed to clear search history');
    }
  }

  @override
  FutureOr<List<Alias>> build() async {
    final encodedAliases = await ref
        .read(flutterSecureStorageProvider)
        .read(key: DataStorageKeys.searchHistoryKey);
    if (encodedAliases == null) return <Alias>[];

    final decodedAliases = jsonDecode(encodedAliases);
    final aliases =
        (decodedAliases as List).map((alias) => Alias.fromJson(alias)).toList();
    return aliases;
  }
}
