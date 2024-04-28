import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/features/aliases/presentation/components/alias_shimmer_loading.dart';
import 'package:anonaddy/features/aliases/presentation/components/alias_tab_emails_stats.dart';
import 'package:anonaddy/features/aliases/presentation/components/empty_list_alias_tab.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/fab_visibility_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasesTab extends ConsumerStatefulWidget {
  const AliasesTab({super.key});

  static const aliasTabScaffold = Key('aliasScreenScaffold');
  static const aliasTabScrollView = Key('aliasTabScrollView');
  static const aliasTabSliverAppBar = Key('aliasTabSliverAppBar');
  static const aliasTabEmailsStats = Key('aliasTabEmailsStats');
  static const aliasTabTabBar = Key('aliasTabTabBar');
  static const aliasTabAvailableAliasesTab = Key('aliasTabAvailableAliasesTab');
  static const aliasTabDeletedAliasesTab = Key('aliasTabDeletedAliasesTab');
  static const aliasTabLoadingTabBarView = Key('aliasTabLoadingTabBarView');
  static const aliasTabLoadedTabBarView = Key('aliasTabLoadedTabBarView');
  static const aliasTabFailedTabBarView = Key('aliasTabFailedTabBarView');
  static const aliasTabAvailableAliasesLoading =
      Key('aliasTabAvailableAliasesLoading');
  static const aliasTabDeletedAliasesLoading =
      Key('aliasTabDeletedAliasesLoading');
  static const aliasTabAvailableAliasListTile =
      Key('aliasTabAvailableAliasListTile');
  static const aliasTabDeletedAliasListTile =
      Key('aliasTabDeletedAliasListTile');

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
    final aliasTabState = ref.watch(aliasesNotifierProvider);

    return Scaffold(
      key: AliasesTab.aliasTabScaffold,

      /// [DefaultTabController] is required when using [TabBar]s without
      /// a custom [TabController]
      body: DefaultTabController(
        length: 1,
        child: NestedScrollView(
          key: AliasesTab.aliasTabScrollView,
          controller:
              ref.read(fabVisibilityStateNotifier.notifier).aliasController,
          headerSliverBuilder: (_, __) {
            return [
              SliverAppBar(
                key: AliasesTab.aliasTabSliverAppBar,
                expandedHeight: size.height * 0.25,
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: AliasTabEmailsStats(
                    key: AliasesTab.aliasTabEmailsStats,
                  ),
                ),
                bottom: const TabBar(
                  key: AliasesTab.aliasTabTabBar,
                  indicatorColor: AppColors.accentColor,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      key: AliasesTab.aliasTabAvailableAliasesTab,
                      text: 'Aliases (active & inactive)',
                    ),
                  ],
                ),
              ),
            ];
          },
          body: aliasTabState.when(
            data: (aliases) {
              return TabBarView(
                key: AliasesTab.aliasTabLoadedTabBarView,
                children: [
                  RefreshIndicator(
                    color: AppColors.accentColor,
                    displacement: 20,
                    onRefresh: () async {
                      await ref
                          .read(aliasesNotifierProvider.notifier)
                          .fetchAliases();
                    },
                    child: aliases.isEmpty
                        ? const EmptyListAliasTabWidget()
                        : PlatformScrollbar(
                            child: ListView.builder(
                              itemCount: aliases.length,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return AliasListTile(
                                  key:
                                      AliasesTab.aliasTabAvailableAliasListTile,
                                  alias: aliases[index],
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
                key: AliasesTab.aliasTabFailedTabBarView,
                children: [ErrorMessageWidget(message: error.toString())],
              );
            },
            loading: () {
              return const TabBarView(
                key: AliasesTab.aliasTabLoadingTabBarView,
                children: [
                  AliasShimmerLoading(
                    key: AliasesTab.aliasTabAvailableAliasesLoading,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
