import 'package:anonaddy/features/aliases/presentation/aliases_tab.dart';
import 'package:anonaddy/notifiers/account/account_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/aliases_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/notifiers/failed_delivery/failed_delivery_notifier.dart';
import 'package:anonaddy/notifiers/recipient/recipients_notifier.dart';
import 'package:anonaddy/notifiers/settings/settings_notifier.dart';
import 'package:anonaddy/screens/account_tab/account_tab.dart';
import 'package:anonaddy/screens/create_alias/create_alias.dart';
import 'package:anonaddy/screens/home_screen/components/alert_center_icon.dart';
import 'package:anonaddy/screens/home_screen/components/changelog_widget.dart';
import 'package:anonaddy/screens/search_tab/quick_search_screen.dart';
import 'package:anonaddy/screens/search_tab/search_tab.dart';
import 'package:anonaddy/screens/settings_screen/settings_screen.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
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
      ref.read(accountNotifierProvider.notifier).fetchAccount();
      ref.read(recipientsNotifier.notifier).fetchRecipients();
    }

    if (index == 1) {
      ref.read(aliasesNotifierProvider.notifier).fetchAliases();
    }
  }

  @override
  void initState() {
    super.initState();

    /// Show [ChangelogWidget] in [HomeScreen] if app has updated
    ref.read(settingsNotifier.notifier).showChangelogIfAppUpdated();

    /// Pre-loads [DomainOptions] data for [CreateAlias]
    ref.read(failedDeliveriesNotifier.notifier).getFailedDeliveries();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    /// Show [ChangelogWidget] if app has been updated
    ref.listen<bool>(
      settingsNotifier
          .select((settingState) => settingState.value?.showChangelog ?? false),
      (_, showChangelog) {
        if (showChangelog) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
              ),
            ),
            builder: (context) => const ChangelogWidget(),
          );
        }
      },
    );

    return Scaffold(
      key: const Key('homeScreenScaffold'),
      appBar: AppBar(
        key: const Key('homeScreenAppBar'),
        elevation: 0,
        title: const Text(
          AppStrings.appName,
          key: Key('homeScreenAppBarTitle'),
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: const AlertCenterIcon(),
        actions: [
          IconButton(
            key: const Key('homeScreenQuickSearchTrailing'),
            tooltip: AppStrings.quickSearch,
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, QuickSearchScreen.routeName);
            },
          ),
          IconButton(
            key: const Key('homeScreenAppBarTrailing'),
            tooltip: AppStrings.settings,
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          ),
        ],
      ),
      floatingActionButton: const CreateAlias(),
      body: IndexedStack(
        key: const Key('homeScreenBody'),
        index: _selectedIndex,
        children: const [
          AccountTab(),
          AliasesTab(),
          SearchTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: const Key('homeScreenBotNavBar'),
        onTap: _switchIndex,
        currentIndex: _selectedIndex,
        selectedItemColor:
            isDark ? AppColors.accentColor : AppColors.primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              key: Key('homeScreenBotNavBarFirstIcon'),
            ),
            label: AppStrings.accountBotNavLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.alternate_email_outlined,
              key: Key('homeScreenBotNavBarSecondIcon'),
            ),
            label: AppStrings.aliasesBotNavLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_outlined,
              key: Key('homeScreenBotNavBarThirdIcon'),
            ),
            label: AppStrings.searchBotNavLabel,
          ),
        ],
      ),
    );
  }
}
