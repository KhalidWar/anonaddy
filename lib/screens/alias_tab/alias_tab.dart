import 'package:animations/animations.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:anonaddy/screens/alias_tab/alias_list_tile.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/main_account_state_manager.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/card_header.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_new_alias.dart';
import 'deleted_aliases_screen.dart';

final aliasDataStream = StreamProvider.autoDispose<AliasModel>((ref) async* {
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
      loading: () => FetchingDataIndicator(),
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
          floatingActionButton: buildFloatingActionButton(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Column(
                    children: [
                      CardHeader(label: 'Stats'),
                      Row(
                        children: [
                          Expanded(
                            child: AliasDetailListTile(
                              title: forwardedList.isEmpty
                                  ? '0'
                                  : '${forwardedList.reduce((value, element) => value + element)}',
                              titleTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              subtitle: 'Emails Forwarded',
                              leadingIconData: Icons.forward_to_inbox,
                            ),
                          ),
                          Expanded(
                            child: AliasDetailListTile(
                              title: sentList.isEmpty
                                  ? '0'
                                  : '${sentList.reduce((value, element) => value + element)}',
                              titleTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
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
                              title: repliedList.isEmpty
                                  ? '0'
                                  : '${repliedList.reduce((value, element) => value + element)}',
                              titleTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              subtitle: 'Emails Replied',
                              leadingIconData: Icons.reply,
                            ),
                          ),
                          Expanded(
                            child: AliasDetailListTile(
                              title: blockedList.isEmpty
                                  ? '0'
                                  : '${blockedList.reduce((value, element) => value + element)}',
                              titleTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
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
                              titleTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              subtitle: 'Available Aliases',
                              leadingIconData: Icons.alternate_email,
                            ),
                          ),
                          Expanded(
                            child: AliasDetailListTile(
                              title: '${deletedAliasList.length}',
                              titleTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              subtitle: 'Deleted Aliases',
                              leadingIconData: Icons.delete_outline_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardHeader(label: 'Aliases'),
                      Column(
                        children: [
                          ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              'Available Aliases',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            children: [
                              availableAliasList.isEmpty
                                  ? emptyAvailableAliasList(context)
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: availableAliasList.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          child: AliasListTile(
                                            aliasData:
                                                availableAliasList[index],
                                          ),
                                          onTap: () {
                                            aliasDataProvider.aliasDataModel =
                                                availableAliasList[index];
                                            aliasDataProvider.setSwitchValue(
                                                availableAliasList[index]
                                                    .isAliasActive);
                                            Navigator.push(
                                              context,
                                              buildPageRouteBuilder(
                                                  AliasDetailScreen()),
                                            );
                                          },
                                        );
                                      },
                                    ),
                            ],
                          ),
                          ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              'Deleted Aliases',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            children: [
                              deletedAliasList.isEmpty
                                  ? emptyDeletedAliasList(context)
                                  : Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              deletedAliasList.length > 10
                                                  ? 10
                                                  : deletedAliasList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              child: AliasListTile(
                                                aliasData:
                                                    deletedAliasList[index],
                                              ),
                                              onTap: () {
                                                aliasDataProvider
                                                        .aliasDataModel =
                                                    deletedAliasList[index];
                                                aliasDataProvider
                                                    .setSwitchValue(
                                                        deletedAliasList[index]
                                                            .isAliasActive);
                                                Navigator.push(
                                                  context,
                                                  buildPageRouteBuilder(
                                                      AliasDetailScreen()),
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
                                              buildPageRouteBuilder(
                                                DeletedAliasesScreen(
                                                  aliasDataModel:
                                                      deletedAliasList,
                                                ),
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
                ),
              ],
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

  Container emptyAvailableAliasList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Text(
        'No available aliases found',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Container emptyDeletedAliasList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Text(
        'No deleted aliases found',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    final username = context.read(mainAccountProvider).accountUsername;
    final createAliasText =
        'Other aliases e.g. alias@${username ?? 'username'}.anonaddy.com or .me can also be created automatically when they receive their first email.';

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModal(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text('Create new alias'),
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(createAliasText),
                SizedBox(height: 10),
                CreateNewAlias(),
              ],
            );
          },
        );
      },
    );
  }
}
