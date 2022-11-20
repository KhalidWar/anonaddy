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

  Future<void> search(String keyword) async {
    if (!mounted) return;
    if (keyword.length >= 3) {
      if (cancelToken.isCancelled) {
        cancelToken = CancelToken();
      }

      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() {
        return searchService.searchAliases(keyword.trim(), cancelToken);
      });
    }
  }

  void cancelSearch() {
    cancelToken.cancel();
  }

  void resetSearch() {
    if (!mounted) return;
    cancelToken.cancel('Search cancelled');
    state = const AsyncData(null);
  }
}
