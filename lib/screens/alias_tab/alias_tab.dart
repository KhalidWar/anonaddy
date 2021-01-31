import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/card_header.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
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
          floatingActionButton: buildFloatingActionButton(context),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardHeader(label: 'Aliases'),
                Row(
                  children: [
                    Expanded(
                      child: AliasDetailListTile(
                        title: forwardedList.isEmpty
                            ? '0'
                            : '${forwardedList.reduce((value, element) => value + element)}',
                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        subtitle: 'Emails Forwarded',
                        leadingIconData: Icons.forward_to_inbox,
                      ),
                    ),
                    Expanded(
                      child: AliasDetailListTile(
                        title: sentList.isEmpty
                            ? '0'
                            : '${sentList.reduce((value, element) => value + element)}',
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
                        title: repliedList.isEmpty
                            ? '0'
                            : '${repliedList.reduce((value, element) => value + element)}',
                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        subtitle: 'Emails Replied',
                        leadingIconData: Icons.reply,
                      ),
                    ),
                    Expanded(
                      child: AliasDetailListTile(
                        title: blockedList.isEmpty
                            ? '0'
                            : '${blockedList.reduce((value, element) => value + element)}',
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
                              return AliasListTile(
                                aliasData: availableAliasList[index],
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
                    deletedAliasList.isEmpty
                        ? emptyDeletedAliasList(context)
                        : Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: deletedAliasList.length > 10
                                    ? 10
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
                  ],
                )
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
    return FloatingActionButton(
      child: Icon(Icons.add),
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
}
