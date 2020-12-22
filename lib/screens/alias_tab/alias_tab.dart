import 'package:animations/animations.dart';
import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:anonaddy/screens/alias_tab/alias_list_tile.dart';
import 'package:anonaddy/screens/alias_tab/create_new_alias.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/card_header.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'deleted_aliases_screen.dart';

final _aliasDataStreamProvider =
    StreamProvider.autoDispose<AliasModel>((ref) async* {
  yield await ref.watch(aliasServiceProvider).getAllAliasesData();
  while (true) {
    await Future.delayed(Duration(seconds: 1));
    yield await ref.read(aliasServiceProvider).getAllAliasesData();
  }
});

final domainOptionsProvider = FutureProvider<DomainOptions>((ref) async {
  return await ref.read(domainOptionsServiceProvider).getDomainOptions();
});

class AliasTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aliasDataStream = watch(_aliasDataStreamProvider);
    // preloads domainOptions for create new alias on FAB click
    watch(domainOptionsProvider);

    return aliasDataStream.when(
      loading: () => FetchingDataIndicator(),
      data: (data) {
        final aliasDataList = data.aliasDataList;
        final availableAliasList = <AliasDataModel>[];
        final deletedAliasList = <AliasDataModel>[];
        final forwardedList = <int>[];
        final blockedList = <int>[];
        final repliedList = <int>[];
        final sentList = <int>[];

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
          floatingActionButton: buildFloatingActionButton(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                buildSearchCard(context, availableAliasList, deletedAliasList),
                buildStatsCard(
                  forwardedList,
                  sentList,
                  repliedList,
                  blockedList,
                  availableAliasList,
                  deletedAliasList,
                ),
                buildAliasesCard(context, availableAliasList, deletedAliasList),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => LottieWidget(
        lottie: 'assets/lottie/errorCone.json',
        label: '$error',
      ),
    );
  }

  Card buildSearchCard(
      BuildContext context,
      List<AliasDataModel> availableAliasList,
      List<AliasDataModel> deletedAliasList) {
    return Card(
      child: GestureDetector(
        onTap: () {
          showSearch(
              context: context,
              delegate: SearchService(
                [...availableAliasList, ...deletedAliasList],
              ));
        },
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            hintText: kSearchHintText,
            prefixIcon: Icon(Icons.search, color: Colors.black),
            disabledBorder: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Card buildStatsCard(
      List<int> forwardedList,
      List<int> sentList,
      List<int> repliedList,
      List<int> blockedList,
      List<AliasDataModel> availableAliasList,
      List<AliasDataModel> deletedAliasList) {
    return Card(
      child: Column(
        children: [
          CardHeader(label: 'Stats'),
          Row(
            children: [
              Expanded(
                child: AliasDetailListTile(
                  title:
                      '${forwardedList.reduce((value, element) => value + element)}',
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  subtitle: 'Emails Forwarded',
                  leadingIconData: Icons.forward_to_inbox,
                ),
              ),
              Expanded(
                child: AliasDetailListTile(
                  title:
                      '${sentList.reduce((value, element) => value + element)}',
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  subtitle: 'Emails Sent',
                  leadingIconData: Icons.mark_email_read_outlined,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AliasDetailListTile(
                  title:
                      '${repliedList.reduce((value, element) => value + element)}',
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  subtitle: 'Emails Replied',
                  leadingIconData: Icons.reply,
                ),
              ),
              Expanded(
                child: AliasDetailListTile(
                  title:
                      '${blockedList.reduce((value, element) => value + element)}',
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  subtitle: 'Emails Blocked',
                  leadingIconData: Icons.block,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AliasDetailListTile(
                  title: '${availableAliasList.length}',
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  subtitle: 'Available Aliases',
                  leadingIconData: Icons.alternate_email,
                ),
              ),
              Expanded(
                child: AliasDetailListTile(
                  title: '${deletedAliasList.length}',
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  subtitle: 'Deleted Aliases',
                  leadingIconData: Icons.delete_outline_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Card buildAliasesCard(
      BuildContext context,
      List<AliasDataModel> availableAliasList,
      List<AliasDataModel> deletedAliasList) {
    final aliasDataProvider = context.read(aliasStateManagerProvider);

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CardHeader(label: 'Aliases'),
          Column(
            children: [
              ExpansionTile(
                title: Text(
                  'Available Aliases',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                initiallyExpanded: true,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: availableAliasList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: AliasListTile(
                          aliasData: availableAliasList[index],
                        ),
                        onTap: () {
                          aliasDataProvider.setAliasDataModel =
                              availableAliasList[index];
                          aliasDataProvider.setSwitchValue(
                              availableAliasList[index].isAliasActive);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AliasDetailScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Deleted Aliases',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                children: [
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: AliasListTile(
                              aliasData: deletedAliasList[index],
                            ),
                            onTap: () {
                              aliasDataProvider.setAliasDataModel =
                                  deletedAliasList[index];
                              aliasDataProvider.setSwitchValue(
                                  availableAliasList[index].isAliasActive);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AliasDetailScreen(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Divider(),
                      FlatButton(
                        child: Text('View full list'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DeletedAliasesScreen(
                                  aliasDataModel: deletedAliasList,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModal(
          context: context,
          builder: (context) {
            final size = MediaQuery.of(context).size;

            return SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              title: Text('Create New Alias'),
              children: [
                Container(
                    height: size.height * 0.4,
                    width: size.width,
                    child: CreateNewAlias()),
              ],
            );
          },
        );
      },
    );
  }
}
