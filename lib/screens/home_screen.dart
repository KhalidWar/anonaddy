import 'package:anonaddy/screens/account_tab/account_tab.dart';
import 'package:anonaddy/screens/alias_tab/alias_tab.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import 'alias_tab/create_new_alias.dart';
import 'more_tab/more_tab.dart';

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
            MoreTab(),
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
              icon: Icon(Icons.more_horiz_rounded),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text('AddyManager', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      leading: IconButton(
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
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                child: CreateNewAlias(),
              );
            },
          );
        },
      ),
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
