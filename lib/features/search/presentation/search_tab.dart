import 'package:anonaddy/features/search/presentation/components/search_history.dart';
import 'package:anonaddy/features/search/presentation/controller/search_history/search_history_notifier.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
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
          const SearchHistory(),
        ],
      ),
    );
  }
}
