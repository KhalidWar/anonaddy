import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_tab_pie_chart.dart';
import 'package:anonaddy/shared_components/shimmer_effects/alias_shimmer_loading.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'deleted_aliases_screen.dart';

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
                          emailsForwarded: forwardedList
                              .reduce((value, element) => value + element),
                          emailsBlocked: blockedList
                              .reduce((value, element) => value + element),
                          emailsReplied: repliedList
                              .reduce((value, element) => value + element),
                          emailsSent: sentList
                              .reduce((value, element) => value + element),
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
                    buildEmptyAliasList(context, 'available')
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
                    buildEmptyAliasList(context, 'deleted')
                  else
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: deletedAliasList.length >= 15
                                ? 15
                                : deletedAliasList.length,
                            itemBuilder: (context, index) {
                              return AliasListTile(
                                aliasData: deletedAliasList[index],
                              );
                            },
                          ),
                          Divider(),
                          TextButton(
                            style: TextButton.styleFrom(),
                            child: Text('View all deleted aliases'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CustomPageRoute(
                                  DeletedAliasesScreen(deletedAliasList),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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

  Container buildEmptyAliasList(BuildContext context, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Text(
        'No $label aliases found',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
