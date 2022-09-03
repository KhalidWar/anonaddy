import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/notifiers/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/notifiers/search/search_history/search_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHistory extends ConsumerStatefulWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _SearchHistoryState();
}

class _SearchHistoryState extends ConsumerState<SearchHistory> {
  @override
  void initState() {
    super.initState();
    ref.read(searchHistoryStateNotifier.notifier).initSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchState = ref.watch(searchHistoryStateNotifier);

    switch (searchState.status) {
      case SearchHistoryStatus.loading:
        return Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: const Center(child: CircularProgressIndicator()),
        );

      case SearchHistoryStatus.loaded:
        final aliases = searchState.aliases;

        if (aliases.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: Row(children: const [Text('Nothing to see here.')]),
          );
        } else {
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
        }

      case SearchHistoryStatus.failed:
        final error = searchState.errorMessage;
        return Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: Row(
            children: [
              Text(error ?? 'Something went wrong: ${error.toString()}'),
            ],
          ),
        );
    }
  }
}
