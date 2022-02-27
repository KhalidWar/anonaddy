import 'package:anonaddy/screens/account_tab/account_tab.dart';
import 'package:anonaddy/screens/alert_center/alert_center_screen.dart';
import 'package:anonaddy/screens/alias_tab/alias_tab.dart';
import 'package:anonaddy/screens/home_screen/components/create_alias_fab.dart';
import 'package:anonaddy/screens/search_tab/search_tab.dart';
import 'package:anonaddy/screens/settings_screen/settings_screen.dart';
import 'package:anonaddy/shared_components/constants/addymanager_string.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/state_management/changelog/changelog_notifier.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = 'homeScreen';

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 1;

  void _switchIndex(int index) {
    ref.read(fabVisibilityStateNotifier.notifier).showFab();
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      ref.read(accountStateNotifier.notifier).refreshAccount();
      ref.read(recipientTabStateNotifier.notifier).refreshRecipients();
    }

    if (index == 1) {
      ref.read(aliasTabStateNotifier.notifier).refreshAliases();
    }
  }

  @override
  void initState() {
    super.initState();

    /// Show [ChangelogWidget] in [HomeScreen] if app has updated
    ref.read(changelogStateNotifier.notifier).showChangelogWidget(context);

    /// Pre-loads [DomainOptions] data for [CreateAlias]
    ref.read(domainOptionsStateNotifier.notifier).fetchDomainOption();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: const CreateAliasFAB(),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          AccountTab(),
          AliasTab(),
          SearchTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _switchIndex,
        currentIndex: _selectedIndex,
        selectedItemColor:
            isDark ? AppColors.accentColor : AppColors.primaryColor,
        items: const [
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
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }
}
