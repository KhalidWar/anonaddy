import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/alert_center/presentation/components/alert_center_icon.dart';
import 'package:anonaddy/features/router/app_router.dart';
import 'package:anonaddy/features/search/presentation/components/search_history.dart';
import 'package:anonaddy/features/search/presentation/controller/search_history_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage(name: 'SearchTabRoute')
class SearchTab extends ConsumerWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          AppStrings.appName,
          key: Key('homeScreenAppBarTitle'),
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: const AlertCenterIcon(),
        actions: [
          IconButton(
            key: const Key('homeScreenQuickSearchTrailing'),
            tooltip: AppStrings.quickSearch,
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () => context.pushRoute(const QuickSearchScreenRoute()),
          ),
          IconButton(
            key: const Key('homeScreenAppBarTrailing'),
            tooltip: AppStrings.settings,
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () => context.pushRoute(const SettingsScreenRoute()),
          ),
        ],
      ),
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
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
                TextButton(
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    ref
                        .read(searchHistoryNotifierProvider.notifier)
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
