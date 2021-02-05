import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_new_alias.dart';
import 'deleted_aliases_screen.dart';

final aliasDataStream = StreamProvider.autoDispose<AliasModel>((ref) async* {
  yield* Stream.fromFuture(ref.read(aliasServiceProvider).getAllAliasesData());
  while (true) {
    await Future.delayed(Duration(seconds: 1));
    yield* Stream.fromFuture(
        ref.read(aliasServiceProvider).getAllAliasesData());
  }
});

final domainOptionsProvider = FutureProvider<DomainOptions>((ref) {
  return ref.read(domainOptionsServiceProvider).getDomainOptions();
});

class AliasTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final stream = watch(aliasDataStream);
    // preloads domainOptions for create new alias on FAB click
    watch(domainOptionsProvider);

    final aliasDataProvider = context.read(aliasStateManagerProvider);
    final availableAliasList = aliasDataProvider.availableAliasList;
    final deletedAliasList = aliasDataProvider.deletedAliasList;
    final forwardedList = aliasDataProvider.forwardedList;
    final blockedList = aliasDataProvider.blockedList;
    final repliedList = aliasDataProvider.repliedList;
    final sentList = aliasDataProvider.sentList;

    return stream.when(
      loading: () => LoadingIndicator(),
      data: (data) {
        final aliasDataList = data.aliasDataList;

        availableAliasList.clear();
        deletedAliasList.clear();
        forwardedList.clear();
        blockedList.clear();
        repliedList.clear();
        sentList.clear();

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
                    expandedHeight: size.height * 0.18,
                    floating: false,
                    pinned: true,
                    title: Text('AddyManager'),
                    centerTitle: true,
                    leading: buildCreateNewAlias(context),
                    actions: [buildSearch(context)],
                    flexibleSpace: buildFlexibleSpaceBar(
                        forwardedList, sentList, repliedList, blockedList),
                    bottom: TabBar(
                      indicatorColor: kAccentColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Available Aliases'),
                              Text('${availableAliasList.length}'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      padding: EdgeInsets.only(top: 0),
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
                            padding: EdgeInsets.only(top: 0),
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
                                buildPageRouteBuilder(
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

  FlexibleSpaceBar buildFlexibleSpaceBar(List<int> forwardedList,
      List<int> sentList, List<int> repliedList, List<int> blockedList) {
    return FlexibleSpaceBar(
      background: Padding(
        padding: EdgeInsets.only(top: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlexSpaceText(
              label: 'Forward',
              digit: forwardedList.isEmpty
                  ? 0
                  : forwardedList.reduce((value, element) => value + element),
            ),
            FlexSpaceText(
              label: 'Sent',
              digit: sentList.isEmpty
                  ? 0
                  : sentList.reduce((value, element) => value + element),
            ),
            FlexSpaceText(
              label: 'Replied',
              digit: repliedList.isEmpty
                  ? 0
                  : repliedList.reduce((value, element) => value + element),
            ),
            FlexSpaceText(
              label: 'Blocked',
              digit: blockedList.isEmpty
                  ? 0
                  : blockedList.reduce((value, element) => value + element),
            ),
          ],
        ),
      ),
    );
  }

  IconButton buildCreateNewAlias(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_circle_outline_outlined),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
              child: CreateNewAlias(),
            );
          },
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

  PageRouteBuilder buildPageRouteBuilder(Widget child) {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondAnimation, child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);

        return SlideTransition(
          position: Tween(
            begin: Offset(1.0, 0.0),
            end: Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondAnimation) {
        return child;
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

class FlexSpaceText extends StatelessWidget {
  const FlexSpaceText({Key key, this.label, this.digit}) : super(key: key);

  final String label;
  final int digit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.white),
        ),
        Text(
          digit.toString(),
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
