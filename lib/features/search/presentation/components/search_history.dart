import 'package:anonaddy/common/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/features/search/presentation/controller/search_history_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHistory extends ConsumerWidget {
  const SearchHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchHistoryNotifierProvider);

    return searchState.when(
      data: (aliases) {
        if (aliases.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Row(children: [Text('Nothing to see here.')]),
          );
        }

        return Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: aliases.length,
            itemBuilder: (context, index) {
              return AliasListTile(alias: aliases[index]);
            },
          ),
        );
      },
      error: (error, stack) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(error.toString()),
        );
      },
      loading: () {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
