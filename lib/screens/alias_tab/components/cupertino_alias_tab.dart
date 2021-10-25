import 'package:anonaddy/screens/create_new_alias/create_new_alias.dart';
import 'package:anonaddy/screens/home_screen_components/alert_center/alert_center_screen.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_providers.dart';
import 'alias_tab_pie_chart.dart';

class CupertinoAliasTab extends StatefulWidget {
  const CupertinoAliasTab({Key? key}) : super(key: key);

  @override
  State<CupertinoAliasTab> createState() => _CupertinoAliasTabState();
}

class _CupertinoAliasTabState extends State<CupertinoAliasTab> {
  int selectedIndex = 0;

  void switchTab(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  Widget availableAliases(AliasTabState aliasTabState) {
    if (aliasTabState.availableAliasList.isEmpty)
      return buildEmptyAliasList(context);
    else
      return PlatformScrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: aliasTabState.availableAliasList.length,
          itemBuilder: (context, index) {
            return AliasListTile(
              aliasData: aliasTabState.availableAliasList[index],
            );
          },
        ),
      );
  }

  Widget deletedAliases(AliasTabState aliasTabState) {
    if (aliasTabState.deletedAliasList.isEmpty)
      return buildEmptyAliasList(context);
    else
      return PlatformScrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: aliasTabState.deletedAliasList.length,
          itemBuilder: (context, index) {
            return AliasListTile(
              aliasData: aliasTabState.deletedAliasList[index],
            );
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final aliasTabState = watch(aliasTabStateNotifier);

        return CupertinoPageScaffold(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CupertinoSliverNavigationBar(
                  stretch: true,
                  largeTitle: Text('Aliases'),
                  leading: IconButton(
                    icon: Icon(Icons.error_outline),
                    onPressed: () {
                      Navigator.pushNamed(context, AlertCenterScreen.routeName);
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(CupertinoIcons.add),
                    onPressed: () {
                      final accountState = context.read(accountStateNotifier);

                      switch (accountState.status) {
                        case AccountStatus.loading:
                          context.read(nicheMethods).showToast(kLoadingText);
                          break;

                        case AccountStatus.loaded:
                          final account = accountState.accountModel!.account;
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(kBottomSheetBorderRadius),
                              ),
                            ),
                            builder: (context) =>
                                CreateNewAlias(account: account),
                          );
                          break;

                        case AccountStatus.failed:
                          context
                              .read(nicheMethods)
                              .showToast(kLoadAccountDataFailed);
                          break;
                      }
                    },
                  ),
                ),
              ];
            },
            body: ListView(
              shrinkWrap: true,
              children: [
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  color: CupertinoColors.inactiveGray,
                  child: Center(
                    child: AliasTabPieChart(
                      emailsForwarded: aliasTabState.forwardedList,
                      emailsBlocked: aliasTabState.blockedList,
                      emailsReplied: aliasTabState.repliedList,
                      emailsSent: aliasTabState.sentList,
                    ),
                  ),
                ),
                Divider(height: 25),
                CupertinoSegmentedControl<int>(
                  groupValue: selectedIndex,
                  onValueChanged: switchTab,
                  padding: EdgeInsets.all(10),
                  children: {
                    0: Text('Available Aliases'),
                    1: Text('Deleted Aliases'),
                  },
                ),
                SizedBox(height: 20),
                if (selectedIndex == 0)
                  availableAliases(aliasTabState)
                else
                  deletedAliases(aliasTabState),
              ],
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
