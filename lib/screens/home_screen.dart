import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/screens/home_screen_components/alert_center/alert_center_screen.dart';
import 'package:anonaddy/screens/search_tab/search_tab.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/shared_components/no_internet_alert.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/state_management/connectivity/connectivity_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'account_tab/account_tab.dart';
import 'alias_tab/alias_tab.dart';
import 'home_screen_components/changelog_widget.dart';
import 'home_screen_components/create_new_alias/create_new_alias.dart';
import 'home_screen_components/settings_screen/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  void _selectedTab(int index) {
    context.read(fabVisibilityStateProvider).showFab();
    if (_selectedIndex == 2 && index == 2) {
      SearchTab().search(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future checkIfAppUpdated() async {
    final changeLog = context.read(changelogService);
    await changeLog.checkIfAppUpdated(context);
    final isUpdated = await changeLog.isAppUpdated();
    if (isUpdated) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(kBottomSheetBorderRadius)),
        ),
        builder: (context) => ChangelogWidget(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfAppUpdated();
    context.read(searchHistoryStorage).openSearchHiveBox();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: buildFab(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          AccountTab(),
          AliasTab(),
          SearchTab(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer(
            builder: (_, watch, __) {
              final connectivityStatus = watch(connectivityStateNotifier);
              return connectivityStatus == ConnectionStatus.offline
                  ? NoInternetAlert()
                  : Container();
            },
          ),
          BottomNavigationBar(
            onTap: _selectedTab,
            currentIndex: _selectedIndex,
            selectedItemColor: isDark ? kAccentColor : kPrimaryColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: kAccountBotNavLabel,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alternate_email_outlined),
                label: kAliasesBotNavLabel,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                label: kSearchBotNavLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text(kAppBarTitle, style: TextStyle(color: Colors.white)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.error_outline),
        onPressed: () {
          Navigator.push(context, CustomPageRoute(AlertCenterScreen()));
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () =>
              Navigator.push(context, CustomPageRoute(SettingsScreen())),
        ),
      ],
    );
  }

  Widget buildFab(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final showFab = watch(fabVisibilityStateNotifier);
        final singleTween = Tween(begin: 0.0, end: 1.0);

        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: singleTween.animate(animation),
              child: showFab ? child : Container(),
            );
          },
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              final accountState = context.read(accountStateNotifier);

              switch (accountState.status) {
                case AccountStatus.loading:
                  context.read(nicheMethods).showToast(kLoadingText);
                  break;

                case AccountStatus.loaded:
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(kBottomSheetBorderRadius),
                      ),
                    ),
                    builder: (context) => CreateNewAlias(),
                  );
                  break;

                case AccountStatus.failed:
                  context.read(nicheMethods).showToast(kLoadAccountDataFailed);
                  break;
              }
            },
          ),
        );
      },
    );
  }
}
