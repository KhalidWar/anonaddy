import 'dart:async';

import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/search/data/search_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quickSearchNotifierProvider =
    AsyncNotifierProvider.autoDispose<QuickSearchNotifier, List<Alias>?>(
        QuickSearchNotifier.new);

class QuickSearchNotifier extends AutoDisposeAsyncNotifier<List<Alias>?> {
  CancelToken cancelToken = CancelToken();

  Timer? timer;

  Future<void> search(String arg) async {
    if (arg.length >= 3) {
      if (cancelToken.isCancelled) {
        cancelToken = CancelToken();
      }

      await _debounceSearch(() async {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() {
          return ref
              .read(searchServiceProvider)
              .searchAliases(arg.trim(), cancelToken);
        });
      });
    }
  }

  void cancelSearch() {
    if (cancelToken.isCancelled) cancelToken = CancelToken();
    cancelToken.cancel('Search cancelled');
  }

  void resetSearch() {
    cancelSearch();
    state = const AsyncData(null);
  }

  Future<void> _debounceSearch(Function() callBack) async {
    const duration = Duration(milliseconds: 500);
    timer?.cancel();
    timer = Timer(duration, callBack);
  }

  @override
  FutureOr<List<Alias>?> build() async {
    return null;
  }
}
