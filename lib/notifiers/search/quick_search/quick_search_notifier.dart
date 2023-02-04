import 'dart:async';
import 'dart:developer';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quickSearchStateNotifier = StateNotifierProvider.autoDispose<
    QuickSearchNotifier, AsyncValue<List<Alias>?>>((ref) {
  final cancelToken = CancelToken();
  final searchService = ref.read(searchServiceProvider);

  ref.onDispose(() => cancelToken.cancel());

  return QuickSearchNotifier(
    searchService: searchService,
    cancelToken: cancelToken,
  );
});

class QuickSearchNotifier extends StateNotifier<AsyncValue<List<Alias>?>> {
  QuickSearchNotifier({
    required this.searchService,
    required this.cancelToken,
  }) : super(const AsyncData(null));

  final SearchService searchService;
  CancelToken cancelToken;
  Timer? timer;

  Future<void> search(String keyword) async {
    if (!mounted) return;
    if (keyword.length >= 3) {
      await _debounceSearch(() async {
        log('keyword: $keyword');
        if (cancelToken.isCancelled) {
          cancelToken = CancelToken();
          return;
        }

        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() {
          return searchService.searchAliases(keyword.trim(), cancelToken);
        });
      });
    }
  }

  void cancelSearch() {
    if (cancelToken.isCancelled) cancelToken = CancelToken();
    cancelToken.cancel('Search cancelled');
  }

  void resetSearch() {
    if (!mounted) return;
    cancelSearch();
    state = const AsyncData(null);
  }

  Future<void> _debounceSearch(Function() callBack) async {
    const duration = Duration(milliseconds: 500);
    timer?.cancel();
    timer = Timer(duration, callBack);
  }
}
