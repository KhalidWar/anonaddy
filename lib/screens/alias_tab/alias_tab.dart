import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_state.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/alias_shimmer_loading.dart';
import 'components/alias_tab_pie_chart.dart';
import 'components/empty_list_alias_tab.dart';

class AliasTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aliasTabState = watch(aliasTabStateNotifier);

    switch (aliasTabState.status) {
      case AliasTabStatus.loading:
        return const AliasShimmerLoading();

      case AliasTabStatus.loaded:
        return const LoadedAliasTab();

      case AliasTabStatus.failed:
        final error = aliasTabState.errorMessage!;
        return LottieWidget(
          showLoading: true,
          lottie: 'assets/lottie/errorCone.json',
          label: error.toString(),
        );
    }
  }
}

class LoadedAliasTab extends StatefulWidget {
  const LoadedAliasTab({Key? key}) : super(key: key);

  @override
  _LoadedAliasTabState createState() => _LoadedAliasTabState();
}

class _LoadedAliasTabState extends State<LoadedAliasTab> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, watch, _) {
        final aliasTabState = watch(aliasTabStateNotifier);
        final availableAliasList = aliasTabState.availableAliasList;
        final deletedAliasList = aliasTabState.deletedAliasList;

        return Scaffold(
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              controller: context
                  .read(fabVisibilityStateNotifier.notifier)
                  .aliasController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: size.height * 0.25,
                    elevation: 0,
                    floating: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: AliasTabPieChart(
                        emailsForwarded: aliasTabState.forwardedList,
                        emailsBlocked: aliasTabState.blockedList,
                        emailsReplied: aliasTabState.repliedList,
                        emailsSent: aliasTabState.sentList,
                      ),
                    ),
                    bottom: TabBar(
                      indicatorColor: kAccentColor,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text('Available Aliases'),
                              Text('${availableAliasList.length}'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text('Deleted Aliases'),
                              Text('${deletedAliasList.length}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  if (availableAliasList.isEmpty)
                    const EmptyListAliasTabWidget()
                  else
                    PlatformScrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: availableAliasList.length,
                        itemBuilder: (context, index) {
                          return AliasListTile(
                            aliasData: availableAliasList[index],
                          );
                        },
                      ),
                    ),
                  if (deletedAliasList.isEmpty)
                    const EmptyListAliasTabWidget()
                  else
                    PlatformScrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: deletedAliasList.length,
                        itemBuilder: (context, index) {
                          return AliasListTile(
                            aliasData: deletedAliasList[index],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
