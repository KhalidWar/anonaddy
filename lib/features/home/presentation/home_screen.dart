import 'package:anonaddy/features/account/presentation/account_tab.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/alert_center/presentation/components/alert_center_icon.dart';
import 'package:anonaddy/features/alert_center/presentation/controller/failed_delivery_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/aliases_tab.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/fab_visibility_state.dart';
import 'package:anonaddy/features/create_alias/presentation/create_alias.dart';
import 'package:anonaddy/features/home/presentation/components/changelog_widget.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/features/search/presentation/quick_search_screen.dart';
import 'package:anonaddy/features/search/presentation/search_tab.dart';
import 'package:anonaddy/features/settings/presentation/controller/settings_notifier.dart';
import 'package:anonaddy/features/settings/presentation/settings_screen.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/utilities/theme.dart';
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
