import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/state_management/search/search_history_notifier.dart';
import 'package:anonaddy/state_management/search/search_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, watch, _) {
        final searchState = watch(searchHistoryStateNotifier);

        switch (searchState.status) {
          case SearchHistoryStatus.loading:
            return Padding(
              padding: EdgeInsets.all(size.height * 0.01),
              child: Center(child: CircularProgressIndicator()),
            );

          case SearchHistoryStatus.loaded:
            final aliases = searchState.aliases;

            if (aliases.isEmpty)
              return Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: Row(children: [Text('Nothing to see here.')]),
              );
            else {
              return Expanded(
                child: PlatformScrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: aliases.length,
                    controller: context
                        .read(fabVisibilityStateNotifier.notifier)
                        .searchController,
                    itemBuilder: (context, index) {
                      return AliasListTile(aliasData: aliases[index]);
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
      },
    );
  }
}
