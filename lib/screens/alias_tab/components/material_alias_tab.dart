import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'alias_tab_pie_chart.dart';

class MaterialAliasTab extends StatefulWidget {
  const MaterialAliasTab({Key? key}) : super(key: key);

  @override
  _MaterialAliasTabState createState() => _MaterialAliasTabState();
}

class _MaterialAliasTabState extends State<MaterialAliasTab> {
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
                    buildEmptyAliasList(context)
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
