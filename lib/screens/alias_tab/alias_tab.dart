import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_tab_pie_chart.dart';
import 'package:anonaddy/shared_components/shimmer_effects/alias_shimmer_loading.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aliasStream = watch(aliasDataStream);

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

    return aliasStream.when(
      loading: () => AliasShimmerLoading(),
      data: (data) {
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
              controller:
                  context.read(fabVisibilityStateProvider).aliasController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: size.height * 0.25,
                    elevation: 0,
                    floating: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: AliasTabPieChart(
                          emailsForwarded: reduceList(forwardedList),
                          emailsBlocked: reduceList(blockedList),
                          emailsReplied: reduceList(repliedList),
                          emailsSent: reduceList(sentList),
                        ),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: availableAliasList.length,
                      itemBuilder: (context, index) {
                        return AliasListTile(
                          aliasData: availableAliasList[index],
                        );
                      },
                    ),
                  if (deletedAliasList.isEmpty)
                    buildEmptyAliasList(context)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: deletedAliasList.length,
                      itemBuilder: (context, index) {
                        return AliasListTile(
                          aliasData: deletedAliasList[index],
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return LottieWidget(
          showLoading: true,
          lottie: 'assets/lottie/errorCone.json',
          label: error.toString(),
        );
      },
    );
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
