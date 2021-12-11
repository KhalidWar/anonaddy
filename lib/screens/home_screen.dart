import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/screens/search_tab/search_tab.dart';
import 'package:anonaddy/screens/settings_screen/settings_screen.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'account_tab/account_tab.dart';
import 'alias_tab/alias_tab.dart';
import 'create_new_alias/create_new_alias.dart';
import 'home_screen_components/alert_center/alert_center_screen.dart';
import 'home_screen_components/changelog_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  void switchIndex(int index) {
    context.read(fabVisibilityStateNotifier.notifier).showFab();
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(kBottomSheetBorderRadius)),
        ),
        builder: (context) => const ChangelogWidget(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfAppUpdated();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: buildFab(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          AccountTab(),
          AliasTab(),
          SearchTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => switchIndex(index),
        currentIndex: _selectedIndex,
        selectedItemColor: isDark ? kAccentColor : kPrimaryColor,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: kAccountBotNavLabel,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.alternate_email_outlined),
            label: kAliasesBotNavLabel,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: kSearchBotNavLabel,
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
        icon: const Icon(Icons.error_outline),
        onPressed: () {
          Navigator.pushNamed(context, AlertCenterScreen.routeName);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, SettingsScreen.routeName);
          },
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
            child: const Icon(Icons.add),
            onPressed: () {
              final accountState = context.read(accountStateNotifier);

              switch (accountState.status) {
                case AccountStatus.loading:
                  NicheMethod.showToast(kLoadingText);
                  break;

                case AccountStatus.loaded:
                  final account = accountState.account!;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(kBottomSheetBorderRadius),
                      ),
                    ),
                    builder: (context) => CreateNewAlias(account: account),
                  );
                  break;

                case AccountStatus.failed:
                  NicheMethod.showToast(kLoadAccountDataFailed);
                  break;
              }
            },
          ),
        );
      },
    );
  }
}
