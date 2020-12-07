import 'package:anonaddy/screens/account_tab/account_tab.dart';
import 'package:anonaddy/screens/alias_tab/alias_tab.dart';
import 'package:anonaddy/screens/settings_tab/settings_tab.dart';
import 'package:anonaddy/widgets/pop_scope_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return WillPopScope(
      onWillPop: () =>
          showDialog(context: context, builder: (context) => PopScopeDialog()),
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
          selectedItemColor: Theme.of(context).appBarTheme.color,
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
      title: SvgPicture.asset(
        'assets/images/logo.svg',
        height: MediaQuery.of(context).size.height * 0.03,
      ),
      centerTitle: true,
    );
  }
}
