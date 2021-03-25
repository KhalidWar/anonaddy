import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/screens/alias_tab/shimmer_loading.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/alias_tab_pie_chart.dart';
import 'package:anonaddy/widgets/custom_page_route.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'deleted_aliases_screen.dart';

final aliasDataStream = StreamProvider.autoDispose<AliasModel>((ref) async* {
  yield* Stream.fromFuture(ref.read(aliasServiceProvider).getAllAliasesData());
  while (true) {
    await Future.delayed(Duration(seconds: 1));
    yield* Stream.fromFuture(
        ref.read(aliasServiceProvider).getAllAliasesData());
  }
});

class AliasTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final aliasStream = watch(aliasDataStream);

    /// preloads domainOptions for create new alias screen
    watch(domainOptionsProvider);

    final aliasDataProvider = watch(aliasStateManagerProvider);
    final clearAllLists = aliasDataProvider.clearAllLists;
    final availableAliasList = aliasDataProvider.availableAliasList;
    final deletedAliasList = aliasDataProvider.deletedAliasList;
    final forwardedList = aliasDataProvider.forwardedList;
    final blockedList = aliasDataProvider.blockedList;
    final repliedList = aliasDataProvider.repliedList;
    final sentList = aliasDataProvider.sentList;

    return aliasStream.when(
      loading: () => ShimmerLoading(),
      data: (data) {
        final aliasDataList = data.aliasDataList;

        clearAllLists();

        for (int i = 0; i < aliasDataList.length; i++) {
          forwardedList.add(aliasDataList[i].emailsForwarded);
          blockedList.add(aliasDataList[i].emailsBlocked);
          repliedList.add(aliasDataList[i].emailsReplied);
          sentList.add(aliasDataList[i].emailsSent);

          if (aliasDataList[i].deletedAt == null) {
            availableAliasList.add(aliasDataList[i]);
          } else {
            deletedAliasList.add(aliasDataList[i]);
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
                    snap: true,
                    elevation: 0,
                    floating: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
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
                      indicatorSize: TabBarIndicatorSize.label,
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
                          FlatButton(
                            child: Text('View all deleted aliases'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CustomPageRoute().customPageRouteBuilder(
                                  DeletedAliasesScreen(
                                    aliasDataModel: deletedAliasList,
                                  ),
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
          label: '$error',
        );
      },
    );
  }

  IconButton buildSearch(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search, color: Colors.white),
      onPressed: () {
        final aliasStateManager = context.read(aliasStateManagerProvider);
        showSearch(
          context: context,
          delegate: SearchService(
            [
              ...aliasStateManager.availableAliasList,
              ...aliasStateManager.deletedAliasList,
            ],
          ),
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
