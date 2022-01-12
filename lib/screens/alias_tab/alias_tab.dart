import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_state.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/alias_animated_list.dart';
import 'components/alias_shimmer_loading.dart';
import 'components/alias_tab_pie_chart.dart';
import 'components/empty_list_alias_tab.dart';

class AliasTab extends StatelessWidget {
  const AliasTab();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      /// [DefaultTabController] is required when using [TabBar]s without
      /// a custom [TabController]
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller:
              context.read(fabVisibilityStateNotifier.notifier).aliasController,
          headerSliverBuilder: (context, _) {
            return [
              SliverAppBar(
                expandedHeight: size.height * 0.25,
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: const AliasTabPieChart(),
                ),
                bottom: TabBar(
                  indicatorColor: kAccentColor,
                  tabs: const [
                    Tab(child: Text('Available Aliases')),
                    Tab(child: Text('Deleted Aliases')),
                  ],
                ),
              ),
            ];
          },
          body: Consumer(
            builder: (context, watch, _) {
              final aliasTabState = watch(aliasTabStateNotifier);

              switch (aliasTabState.status) {

                /// When AliasTab is fetching data (loading)
                case AliasTabStatus.loading:
                  return TabBarView(
                    children: const [
                      AliasShimmerLoading(),
                      AliasShimmerLoading(),
                    ],
                  );

                /// When AliasTab has loaded and has data to display
                case AliasTabStatus.loaded:
                  final availableAliasList = aliasTabState.availableAliasList;
                  final deletedAliasList = aliasTabState.deletedAliasList;

                  return TabBarView(
                    children: [
                      /// Available aliases list
                      RefreshIndicator(
                        color: kAccentColor,
                        displacement: 20,
                        onRefresh: () async {
                          await context
                              .read(aliasTabStateNotifier.notifier)
                              .refreshAliases();
                        },
                        child: availableAliasList.isEmpty
                            ? const EmptyListAliasTabWidget()
                            : PlatformScrollbar(
                                child: AliasAnimatedList(
                                  listKey: aliasTabState.availableListKey,
                                  itemCount: availableAliasList.length,
                                  itemBuilder: (context, index) {
                                    return AliasListTile(
                                      aliasData: availableAliasList[index],
                                    );
                                  },
                                ),
                              ),
                      ),

                      /// Deleted aliases list
                      RefreshIndicator(
                        onRefresh: () async {
                          await context
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
                                      aliasData: deletedAliasList[index],
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  );

                /// When AliasTab has failed and has an error message
                case AliasTabStatus.failed:
                  final error = aliasTabState.errorMessage!;
                  return TabBarView(
                    children: [
                      LottieWidget(
                        lottie: 'assets/lottie/errorCone.json',
                        label: error.toString(),
                        lottieHeight: size.height * 0.2,
                      ),
                      LottieWidget(
                        lottie: 'assets/lottie/errorCone.json',
                        label: error.toString(),
                        lottieHeight: size.height * 0.2,
                      ),
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
