import 'package:anonaddy/screens/account_tab/account_tab.dart';
import 'package:anonaddy/screens/alias_tab/alias_tab.dart';
import 'package:anonaddy/screens/settings_tab/settings_tab.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  void _selectedTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Scaffold(
        appBar: buildAppBar(context),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            AccountTab(),
            AliasTab(),
            SettingsTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectedTab,
          currentIndex: _selectedIndex,
          selectedItemColor: isDark ? kAccentColor : kBlueNavyColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alternate_email_sharp),
              label: 'Aliases',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'AddyManager',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        IconButton(
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
        ),
      ],
    );
  }
}
