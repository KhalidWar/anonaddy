import 'package:anonaddy/notifiers/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/alias_tab_state.dart';
import 'package:anonaddy/notifiers/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_shimmer_loading.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_emails_stats.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/screens/alias_tab/components/empty_list_alias_tab.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasTab extends ConsumerStatefulWidget {
  const AliasTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AlisTabState();
}

class _AlisTabState extends ConsumerState<AliasTab> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// Initially, get data from disk (secure device storage) and assign it
      ref.read(aliasTabStateNotifier.notifier).loadDataFromStorage();

      /// Fetch the latest Aliases data from server
      ref.read(aliasTabStateNotifier.notifier).fetchAvailableAliases();
      ref.read(aliasTabStateNotifier.notifier).fetchDeletedAliases();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: AliasTabWidgetKeys.aliasTabScaffold,

      /// [DefaultTabController] is required when using [TabBar]s without
      /// a custom [TabController]
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          key: AliasTabWidgetKeys.aliasTabScrollView,
          controller:
              ref.read(fabVisibilityStateNotifier.notifier).aliasController,
          headerSliverBuilder: (_, __) {
            return [
              SliverAppBar(
                key: AliasTabWidgetKeys.aliasTabSliverAppBar,
                expandedHeight: size.height * 0.25,
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: AliasTabEmailsStats(
                    key: AliasTabWidgetKeys.aliasTabEmailsStats,
                  ),
                ),
                bottom: const TabBar(
                  key: AliasTabWidgetKeys.aliasTabTabBar,
                  indicatorColor: AppColors.accentColor,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      key: AliasTabWidgetKeys.aliasTabAvailableAliasesTab,
                      child: Text('Available Aliases'),
                    ),
                    Tab(
                      key: AliasTabWidgetKeys.aliasTabDeletedAliasesTab,
                      child: Text('Deleted Aliases'),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Consumer(
            builder: (_, ref, __) {
              final aliasTabState = ref.watch(aliasTabStateNotifier);

              switch (aliasTabState.status) {

                /// When AliasTab is fetching data (loading)
                case AliasTabStatus.loading:
                  return const TabBarView(
                    key: AliasTabWidgetKeys.aliasTabLoadingTabBarView,
                    children: [
                      AliasShimmerLoading(
                        key: AliasTabWidgetKeys.aliasTabAvailableAliasesLoading,
                      ),
                      AliasShimmerLoading(
                        key: AliasTabWidgetKeys.aliasTabDeletedAliasesLoading,
                      ),
                    ],
                  );

                /// When AliasTab has loaded and has data to display
                case AliasTabStatus.loaded:
                  final availableAliasList = aliasTabState.availableAliasList;
                  final deletedAliasList = aliasTabState.deletedAliasList;

                  return TabBarView(
                    key: AliasTabWidgetKeys.aliasTabLoadedTabBarView,
                    children: [
                      /// Available aliases list
                      RefreshIndicator(
                        color: AppColors.accentColor,
                        displacement: 20,
                        onRefresh: () async {
                          await ref
                              .read(aliasTabStateNotifier.notifier)
                              .refreshAliases();
                        },
                        child: availableAliasList.isEmpty
                            ? const EmptyListAliasTabWidget()
                            : PlatformScrollbar(
                                child: ListView.builder(
                                  itemCount: availableAliasList.length,
                                  itemBuilder: (context, index) {
                                    return AliasListTile(
                                      key: AliasTabWidgetKeys
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
                              .read(aliasTabStateNotifier.notifier)
                              .refreshAliases();
                        },
                        child: deletedAliasList.isEmpty
                            ? const EmptyListAliasTabWidget()
                            : PlatformScrollbar(
                                child: ListView.builder(
                                  itemCount: deletedAliasList.length,
                                  itemBuilder: (context, index) {
                                    return AliasListTile(
                                      key: AliasTabWidgetKeys
                                          .aliasTabDeletedAliasListTile,
                                      alias: deletedAliasList[index],
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  );

                /// When AliasTab has failed and has an error message
                case AliasTabStatus.failed:
                  final error = aliasTabState.errorMessage;
                  return TabBarView(
                    key: AliasTabWidgetKeys.aliasTabFailedTabBarView,
                    children: [
                      ErrorMessageWidget(message: error),
                      ErrorMessageWidget(message: error),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
