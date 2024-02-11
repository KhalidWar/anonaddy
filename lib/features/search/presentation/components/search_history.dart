import 'package:anonaddy/features/search/presentation/controller/search_history/search_history_notifier.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHistory extends ConsumerWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final searchState = ref.watch(searchHistoryStateNotifier);

    return searchState.when(
      data: (aliases) {
        if (aliases.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: const Row(children: [Text('Nothing to see here.')]),
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
          padding: EdgeInsets.all(size.height * 0.01),
          child: Row(
            children: [
              Text(error.toString()),
            ],
          ),
        );
      },
      loading: () {
        return Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
