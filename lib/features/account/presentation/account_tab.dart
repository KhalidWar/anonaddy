import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/alert_center/presentation/components/alert_center_icon.dart';
import 'package:anonaddy/features/domains/presentation/controller/domains_tab_notifier.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/features/router/app_router.dart';
import 'package:anonaddy/features/rules/presentation/controller/rules_tab_notifier.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage(name: 'AccountTabRoute')
class AccountTab extends ConsumerWidget {
  const AccountTab({super.key});

  static const accountTabScaffold = Key('accountTabScaffold');
  static const accountTabSliverAppBar = Key('accountTabSliverAppBar');
  static const accountTabHeader = Key('accountTabHeader');

  void refreshData(WidgetRef ref, int index) {
    switch (index) {
      case 0:
        ref.read(accountNotifierProvider.notifier).fetchAccount();
        break;
      case 1:
        ref.read(recipientsNotifierProvider.notifier).fetchRecipients();
        break;
      case 2:
        ref.read(usernamesNotifierProvider.notifier).fetchUsernames();
        break;
      case 3:
        ref.read(domainsNotifierProvider.notifier).fetchDomains();
        break;
      case 4:
        ref.read(rulesTabNotifierProvider.notifier).fetchRules();
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsRouter.tabBar(
      routes: const [
        AccountInfoRoute(),
        RecipientsTabRoute(),
        UsernamesTabRoute(),
        DomainsTabRoute(),
        RulesTabRoute(),
      ],
      builder: (context, child, controller) {
        refreshData(ref, controller.index);

        return Scaffold(
          body: child,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
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
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  context.pushRoute(const QuickSearchScreenRoute());
                },
              ),
              IconButton(
                key: const Key('homeScreenAppBarTrailing'),
                tooltip: AppStrings.settings,
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => context.pushRoute(const SettingsScreenRoute()),
              ),
            ],
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.accentColor,
              controller: controller,
              tabs: const [
                Tab(text: AppStrings.account),
                Tab(text: AppStrings.recipients),
                Tab(text: AppStrings.usernames),
                Tab(text: AppStrings.domains),
                Tab(text: AppStrings.rules),
              ],
            ),
          ),
        );
      },
    );
  }
}
