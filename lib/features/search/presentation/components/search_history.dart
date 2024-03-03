import 'package:anonaddy/features/search/presentation/controller/search_history_notifier.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHistory extends ConsumerWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchHistoryStateNotifier);

    return searchState.when(
      data: (aliases) {
        if (aliases.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Row(children: [Text('Nothing to see here.')]),
          );
        }

        return Expanded(
          child: PlatformScrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: aliases.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return AliasListTile(alias: aliases[index]);
              },
            ),
          ),
        );
      },
      error: (error, stack) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(error.toString()),
            ],
          ),
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
