import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/alias_state/alias_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_state.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';
import 'components/alias_shimmer_loading.dart';
import 'components/alias_tab_pie_chart.dart';

class AliasTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aliasState = watch(aliasStateNotifier);

    /// preloads domainOptions for create new alias screen
    watch(domainOptionsProvider);

    final size = MediaQuery.of(context).size;

    final List<Alias> availableAliasList = [];
    final List<Alias> deletedAliasList = [];
    final List<int> forwardedList = [];
    final List<int> blockedList = [];
    final List<int> repliedList = [];
    final List<int> sentList = [];

    int reduceList(List<int> list) {
      if (list.isEmpty) {
        return 0;
      } else {
        return list.reduce((value, element) => value + element);
      }
    }

    switch (aliasState.status) {
      case AliasStatus.loading:
        return AliasShimmerLoading();

      case AliasStatus.loaded:
        final data = aliasState.aliasModel!;

        for (Alias alias in data.aliases) {
          forwardedList.add(alias.emailsForwarded);
          blockedList.add(alias.emailsBlocked);
          repliedList.add(alias.emailsReplied);
          sentList.add(alias.emailsSent);

          if (alias.deletedAt == null) {
            availableAliasList.add(alias);
          } else {
            deletedAliasList.add(alias);
          }
        }

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
                        emailsForwarded: reduceList(forwardedList),
                        emailsBlocked: reduceList(blockedList),
                        emailsReplied: reduceList(repliedList),
                        emailsSent: reduceList(sentList),
                      ),
                    ),
                    bottom: TabBar(
                      indicatorColor: kAccentColor,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Available Aliases'),
                              Text('${availableAliasList.length}'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Deleted Aliases'),
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
                    buildEmptyAliasList(context)
                  else
                    Scrollbar(
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
                    buildEmptyAliasList(context)
                  else
                    Scrollbar(
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

      case AliasStatus.failed:
        final error = aliasState.errorMessage!;
        return LottieWidget(
          showLoading: true,
          lottie: 'assets/lottie/errorCone.json',
          label: error.toString(),
        );
    }
  }

  Center buildEmptyAliasList(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Text(
        'It doesn\'t look like you have any aliases yet!',
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: isDark ? Colors.white : kPrimaryColor),
      ),
    );
  }
}
