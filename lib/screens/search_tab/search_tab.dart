import 'package:anonaddy/notifiers/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/notifiers/search/search_history/search_history_state.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTab extends ConsumerWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.searchHistory,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.white),
                ),
                TextButton(
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    ref
                        .read(searchHistoryStateNotifier.notifier)
                        .clearSearchHistory();
                  },
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final searchState = ref.watch(searchHistoryStateNotifier);

              switch (searchState.status) {
                case SearchHistoryStatus.loading:
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );

                case SearchHistoryStatus.loaded:
                  final aliases = searchState.aliases;

                  if (aliases.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child:
                          Row(children: const [Text('Nothing to see here.')]),
                    );
                  } else {
                    return Expanded(
                      child: PlatformScrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: aliases.length,
                          // physics: const NeverScrollableScrollPhysics(),
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
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(error ??
                            'Something went wrong: ${error.toString()}'),
                      ],
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
