import 'package:anonaddy/features/alert_center/presentation/alert_center_screen.dart';
import 'package:anonaddy/features/settings/presentation/settings_screen.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformHomeScreen extends PlatformAware {
  const PlatformHomeScreen({
    Key? key,
    required this.fab,
    required this.child,
    required this.actions,
    required this.isDark,
    required this.currentIndex,
    required this.androidOnTap,
    required this.iosOnTap,
  }) : super(key: key);

  final Widget fab;
  final Widget child;
  final List<Widget>? actions;

  /// Bot Nav Bar
  final bool isDark;
  final int currentIndex;
  final void Function(int)? androidOnTap;
  final Widget Function(BuildContext, int) iosOnTap;

  List<BottomNavigationBarItem> botNavBarItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_outlined),
        label: AppStrings.accountBotNavLabel,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.alternate_email_outlined),
        label: AppStrings.aliasesBotNavLabel,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search_outlined),
        label: AppStrings.searchBotNavLabel,
      ),
    ];
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        tabBuilder: iosOnTap,
        tabBar: CupertinoTabBar(
          currentIndex: currentIndex,
          // onTap: androidOnTap,
          items: botNavBarItems(),
        ),
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          AppStrings.appName,
          style: TextStyle(color: Colors.white),
        ),
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
      ),
      floatingActionButton: fab,
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: androidOnTap,
        currentIndex: currentIndex,
        selectedItemColor:
            isDark ? AppColors.accentColor : AppColors.primaryColor,
        items: botNavBarItems(),
      ),
    );
  }
}
