import 'package:anonaddy/notifiers/alias_state/aliases_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_shimmer_loading.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_emails_stats.dart';
import 'package:anonaddy/screens/alias_tab/components/aliases_tab_widget_keys.dart';
import 'package:anonaddy/screens/alias_tab/components/empty_list_alias_tab.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasesTab extends ConsumerStatefulWidget {
  const AliasesTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AlisTabState();
}

class _AlisTabState extends ConsumerState<AliasesTab> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// Initially, get data from disk (secure device storage) and assign it
      // ref.read(aliasesNotifierProvider.notifier).loadDataFromStorage();

      /// Fetch the latest Aliases data from server
      ref.read(aliasesNotifierProvider.notifier).fetchAliases();
      // ref.read(aliasesNotifierProvider.notifier).fetchDeletedAliases();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: AliasesTabWidgetKeys.aliasTabScaffold,

      /// [DefaultTabController] is required when using [TabBar]s without
      /// a custom [TabController]
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          key: AliasesTabWidgetKeys.aliasTabScrollView,
          controller:
              ref.read(fabVisibilityStateNotifier.notifier).aliasController,
          headerSliverBuilder: (_, __) {
            return [
              SliverAppBar(
                key: AliasesTabWidgetKeys.aliasTabSliverAppBar,
                expandedHeight: size.height * 0.25,
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: AliasTabEmailsStats(
                    key: AliasesTabWidgetKeys.aliasTabEmailsStats,
                  ),
                ),
                bottom: const TabBar(
                  key: AliasesTabWidgetKeys.aliasTabTabBar,
                  indicatorColor: AppColors.accentColor,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      key: AliasesTabWidgetKeys.aliasTabAvailableAliasesTab,
                      child: Text('Available Aliases'),
                    ),
                    Tab(
                      key: AliasesTabWidgetKeys.aliasTabDeletedAliasesTab,
                      child: Text('Deleted Aliases'),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Consumer(
            builder: (_, ref, __) {
              final aliasTabState = ref.watch(aliasesNotifierProvider);

              return aliasTabState.when(
                data: (aliases) {
                  final availableAliasList = aliases.availableAliases;
                  final deletedAliasList = aliases.deletedAliases;

                  return TabBarView(
                    key: AliasesTabWidgetKeys.aliasTabLoadedTabBarView,
                    children: [
                      /// Available aliases list
                      RefreshIndicator(
                        color: AppColors.accentColor,
                        displacement: 20,
                        onRefresh: () async {
                          await ref
                              .read(aliasesNotifierProvider.notifier)
                              .fetchAliases();
                        },
                        child: availableAliasList.isEmpty
                            ? const EmptyListAliasTabWidget()
                            : PlatformScrollbar(
                                child: ListView.builder(
                                  itemCount: availableAliasList.length,
                                  itemBuilder: (context, index) {
                                    return AliasListTile(
                                      key: AliasesTabWidgetKeys
                                          .aliasTabAvailableAliasListTile,
                                      alias: availableAliasList[index],
                                    );
                                  },
                                ),
                              ),
                      ),

                      /// Deleted aliases list
                      RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(aliasesNotifierProvider.notifier)
                              .fetchAliases();
                        },
                        child: deletedAliasList.isEmpty
                            ? const EmptyListAliasTabWidget()
                            : PlatformScrollbar(
                                child: ListView.builder(
                                  itemCount: deletedAliasList.length,
                                  itemBuilder: (context, index) {
                                    return AliasListTile(
                                      key: AliasesTabWidgetKeys
                                          .aliasTabDeletedAliasListTile,
                                      alias: deletedAliasList[index],
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  );
                },
                error: (error, _) {
                  return TabBarView(
                    key: AliasesTabWidgetKeys.aliasTabFailedTabBarView,
                    children: [
                      ErrorMessageWidget(message: error.toString()),
                      ErrorMessageWidget(message: error.toString()),
                    ],
                  );
                },
                loading: () {
                  return const TabBarView(
                    key: AliasesTabWidgetKeys.aliasTabLoadingTabBarView,
                    children: [
                      AliasShimmerLoading(
                        key: AliasesTabWidgetKeys
                            .aliasTabAvailableAliasesLoading,
                      ),
                      AliasShimmerLoading(
                        key: AliasesTabWidgetKeys.aliasTabDeletedAliasesLoading,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
